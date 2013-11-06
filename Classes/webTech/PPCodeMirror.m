//
//  PPCodeMirror.m
//  ParseParty
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPCodeMirror.h"
#import <CocoaPlus/WebView+Plus.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <StandardPaths/StandardPaths.h>
#import <MantleFoundation/NSAttributedString+MantleFoundation.h>
#include <sys/xattr.h>


@interface PPCodeMirror ()

@property					PPCodeMirrorStatus		status;
@property (strong)			WebViewJavascriptBridge *webViewbridge;

@end

@implementation PPCodeMirror

- (id)initWithFrame:(NSRect)frame frameName:(NSString *)frameName groupName:(NSString *)groupName
{
    self = [super initWithFrame:frame frameName:(NSString *)frameName groupName:(NSString *)groupName];
    if (self) {
        // Initialization code here.
        NSLog(@"CM from frame %@ %@", self, self.identifier);
//		[self loadMe];
        
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
	NSLog(@"CM from nib %@ %@", self, self.identifier);
	[self loadMe];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)loadMe
{
	
	
	NSArray *resourceData = @[
							  
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPJQueryBundle"],
								 @"resources": @[@"jquery.min.js"] },
							  
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPUnderscoreBundle"],
								 @"resources": @[@"underscore.js"] },
							  
							  // CodeMirror________
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPCodeMirrorBundle"],
								 @"resources":
									 @[
										 @"codemirror.css",
										 @"codemirror.js",
										 @"runmode.js",
										 @"css.js",
										 @"sass.js",
										 @"less.js",
										 @"closebrackets.js",
										 @"matchbrackets.js"
									   ]
								 },
							  //__________________
							  
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPAngularJSBundle"],
								 @"resources": @[@"angular.js",
												 @"angular-route.js",
												 ] },
							  
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPMainScriptBundle"],
								 @"resources": @[@"app.js",
												 @"controllers.js",
												 @"directives.js",
												 @"filters.js",
												 @"services.js"
												 ] },
							  
							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPScriptBundle"],
								 @"resources": @(YES) }
							  
							  ];
	
	
	
	NSMutableArray *allResourcePaths = [NSMutableArray array];
	NSMutableArray *allResourceNames = [NSMutableArray array];
	
	
	
	for (NSDictionary *data in resourceData) {
		NSBundle	*bundle		= data[@"bundle"];
		NSArray		*resources	= data[@"resources"];
		NSArray *allInBundle = [[NSBundle pathsForResourcesOfType:@"css" inDirectory:bundle.bundlePath]
								arrayByAddingObjectsFromArray:[NSBundle pathsForResourcesOfType:@"js" inDirectory:bundle.bundlePath]];
		
		
		BOOL allFlag = [resources isEqual:@(YES)];
		
		if (allFlag) {
			
			for (NSString *resourcePath in allInBundle) {
				[allResourcePaths addObject:[[NSURL fileURLWithPath:resourcePath] path]];
				[allResourceNames addObject:resourcePath.lastPathComponent];
			}
		}
		else {
			for (NSString *resourcePath in allInBundle) {
				if ([resources indexOfObject:resourcePath.lastPathComponent] != NSNotFound) {
					[allResourcePaths addObject:[[NSURL fileURLWithPath:resourcePath] path]];
					
				}
			}
			[allResourceNames addObjectsFromArray:resources];
		}
	}
	
	
	
	NSFileManager *fm	= [NSFileManager new];
	fm.delegate			= self;
	
	for (NSString *resourcePath in allResourcePaths) {
		[self replaceItemAtPath:[fm pathForOfflineFile:resourcePath.lastPathComponent] withItemAtPath:resourcePath usingFileManager:fm];
	}
	
	
	
	WebView *dummyWV = [WebView webViewWithBlankPage];
	
	[dummyWV.htmlTag setAttribute:@"ng-app" value:@"myApp"];
	
	for (NSString *resourceName in allResourceNames) {
		if ([resourceName.pathExtension isEqualToString:@"css"]) [dummyWV.headTag appendChild:[dummyWV newLinkStylesheetTag:resourceName]];
		else if ([resourceName.pathExtension isEqualToString:@"js"]) [dummyWV.headTag appendChild:[dummyWV newScriptTag:resourceName]];
	}
	
	DOMHTMLElement *view = [dummyWV newDivTagWithID:nil classes:@[@"ng-view"] innerHTML:nil];
	[dummyWV.bodyTag appendChild:view];
	// TODO: Figure out why evaluateWebScript: doesn't work.
	NSString *fullContents = [NSString stringWithFormat:@"<!DOCTYPE html>%@", dummyWV.outerHTML];
	
	
	
	
	
	
	
	
	NSString *newHtmlPath = [fm pathForOfflineFile:@"pp-index.html"];
	
	[fullContents writeToFile:newHtmlPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	
	
	
	
	self.mainFrameURL = newHtmlPath;
	
	
	
	
	
	
	self.webViewbridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback callback) {
		
		NSLog(@"from CM: %@", data);
		PPCodeMirrorStatus statusWas = self.status;
		if (statusWas == PPCodeMirrorStatusUnloaded) {
			self.status = PPCodeMirrorStatusReady;
		}


		if (self.loadDelegate && statusWas == PPCodeMirrorStatusUnloaded) {
			// TODO: enable this
			[self.loadDelegate parserLoaded:(ParseParty *)self];
		}
	}];
	
	[self.webViewbridge registerHandler:@"action" handler:^(id _data, WVJBResponseCallback callback) {
		
		NSMutableDictionary	*data		= [_data mutableCopy];
		NSDictionary		*parseData	= data[@"parseData"];
		
		self.docLength = [data[@"docLength"] unsignedIntegerValue];
		
		SEL selector = NSSelectorFromString(@"processParseData:");
		if (parseData && [self respondsToSelector:selector]) {
			
			[self performSelector:selector withObject:parseData];
			
		}
		
		
		// Callback back to JS
		callback(@{ @"message": @(YES) });
		

		// Callback to delegate
		if ([self.actionDelegate respondsToSelector:@selector(parserAction:)]) {

			[self.actionDelegate parserAction:data];
		}
	}];
}


- (NSBundle *)bundleInMainBundleNamed:(NSString *)bundleName
{
	return [NSBundle bundleWithPath:[[NSBundle mainBundle]
					pathForResource:bundleName
							 ofType:@"bundle"]];
}







- (void)replaceItemAtPath:(NSString *)originalItemPath withItemAtPath:(NSString *)newItemPath usingFileManager:(NSFileManager *)fm
{
	NSMutableArray *errors  = [NSMutableArray array];

	
	NSURL *newItemURL = [self resolvedAliasFileURL:[NSURL fileURLWithPath:newItemPath]] ? : [NSURL fileURLWithPath:newItemPath];
	newItemPath = newItemURL.path;
	
	// Choose temp directory path
	NSString *tempDirPath = [fm pathForTemporaryFile:newItemPath.lastPathComponent.stringByDeletingPathExtension];

	// Create temp directory
	NSError *error1;
	[fm createDirectoryAtPath:tempDirPath withIntermediateDirectories:NO attributes:nil error:&error1];
	if (error1) [errors addObject:error1];

//	NSLog(@"exists: %@", ([fm fileExistsAtPath:newItemPath] ? @"YES" : @"NO" ));
	
	
	
	// Copy file to temp directory
	NSError *error15;
	[fm copyItemAtPath:newItemPath toPath:[tempDirPath stringByAppendingPathComponent:newItemPath.lastPathComponent] error:&error15];
	if (error15) [errors addObject:error15];
	
	// Copy from temp directory to new dir
	NSError* error3;
	[fm replaceItemAtURL:[NSURL fileURLWithPath:originalItemPath] withItemAtURL:[NSURL fileURLWithPath:[tempDirPath stringByAppendingPathComponent:newItemPath.lastPathComponent]] backupItemName:[NSString stringWithFormat:@"_%@", originalItemPath.lastPathComponent] options:0 resultingItemURL:nil error:&error3];
	if (error3) [errors addObject:error3];
		


	// Delete temp directory
	NSError *error4;
	[fm removeItemAtPath:tempDirPath error:&error4];
	if (error4) [errors addObject:error4];
	
	for (NSError *error in errors) {
		NSLog(@"replaceItem error: %@", error.localizedDescription);
	}
	

}

- (NSURL *)resolvedAliasFileURL:(NSURL *)aliasFileURL
{
	NSMutableArray *errors = [NSMutableArray array];
	NSURL *resolvedFileURL = nil;
	
	NSError *error14;
	NSData *bookmarkData = [NSURL bookmarkDataWithContentsOfURL:aliasFileURL error:&error14];
	if (error14 && error14.code != 256) [errors addObject:error14];
		
	
	if (bookmarkData) {
//		BOOL isStale;
//		
//		NSError *error;
//		NSURL *bURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:&isStale error:&error];
//		if (error) [errors addObject:error];
//		
//		if (isStale == YES) {
//			NSLog(@"Bookmark is stale :(");
//		}
		
		NSDictionary *values = [NSURL resourceValuesForKeys:@[NSURLPathKey] fromBookmarkData:bookmarkData];
		resolvedFileURL = [NSURL fileURLWithPath:values[NSURLPathKey]];
		
	}
	
	for (NSError *error in errors) {
		NSLog(@"alias error: %@", error.localizedDescription);
	}

	return resolvedFileURL;
}




- (void)tokenize:(NSString *)string mode:(NSString *)mode tokens:(PPTokensBlock)tokensBlock
{
//	NSLog(@"tokenizing...");

	NSDictionary *data = @{ @"string": string,
							@"mode": mode };
	
	[self.webViewbridge callHandler:@"tokenize" data:data responseCallback:^(id responseData) {
		NSLog(@"tokenized!");
		NSDictionary *newData = responseData;
		
		NSArray *tokens = newData[@"tokens"];
		
		tokensBlock(tokens);
	}];
	
}


//- (NSString *)pathForOfflineHTMLFile:(NSString *)file
//{
//    return [[self offlineDataPathForHTML] stringByAppendingPathComponent:file];
//}
//
//



	
//	NSTextStorage *sample = [NSTextStorage alloc] initWithString:@"z" attributes:

//	[self.webViewbridge registerHandler:@"log" handler:^(id data, WVJBResponseCallback responseCallback) {
//		NSLog(@"webBridge: %@", data);
//	}];

//}

//- (RACSignal *)syncOP:(cdCommit *)changeToSync
//{
//
////	RACSignal *syncOp = (RACSignal *)objc_getAssociatedObject(self, &genericTextStorageSyncOpKey);
//	@weakify(self);
//	
//	if (_syncOp) return _syncOp;
//		
//		
//	_syncOp = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//		@strongify(self);
////			DDLogVerbose(@"starting new CM syncOp...");
//		
//		
//		RACSignal *lastSelfChangeSignal = [self.codeMirrorDidEditWithChangeSignal startWith:nil].replayLast;
//		[[lastSelfChangeSignal take:1] subscribeNext:^(cdCommit *lastSelfChange) {
//			
////			DDLogVerbose(@"CM sync op with\n%@\n%@", changeToSync.id.UUIDString, lastSelfChange.id.UUIDString);
//			
//			BOOL textViewChangeIsAlreadyStaged		= [changeToSync.id isEqual:lastSelfChange.id];
//			
//			if (!textViewChangeIsAlreadyStaged) {
//				
//				
//				NSDictionary *data;
//				
//				data = @{  @"change": @{ @"id"				: @{ @"UUIDString"			: changeToSync.id.UUIDString },
//										 @"editedRange"		: @{ @"location"			: @(changeToSync.editedRange.location),
//																 @"length"				: @(changeToSync.editedRange.length) },
//										 @"changeInLength"	: @(changeToSync.changeInLength),
//										 @"editedSubstring"	: [NSJSONSerialization attributedStringToDictionary:changeToSync.editedSubstring]
//										 },
//						   @"syntax": @"scss" };
////				DDLogVerbose(@"Edit came from elsewhere. Syncing... %@", data[@"change"][@"editedSubstring"]);
//				
//				[self.webViewbridge callHandler:@"CodeMirrorCommand" data:data responseCallback:^(id responseData) {
//					
//					NSDictionary *responseJSON = responseData;
//					id error                   = responseJSON[@"error"];
////					NSString *content          = responseJSON[@"content"];
//					
//					if (error) {
//						NSLog(@"%@", error);
//						return;
//					}
//					
//					// TODO: Make sure the signal replays all values
//					RACSignal *cmSentChange = [[self.codeMirrorDidEditWithChangeSignal filter:^BOOL(cdCommit *changeSentFromCM) {
//						return [changeToSync.id isEqual:changeSentFromCM.id];
//					}] take:1].replayLast;
//					
//					[cmSentChange subscribe:subscriber];
////					[cmSentChange subscribeCompleted:^{
////						[subscriber sendCompleted];
////					}];
//					
//				}];
//			
//				} else {
////					DDLogVerbose(@"CM was already synceed.");
//					[subscriber sendNext:changeToSync];
//					[subscriber sendCompleted];
//				}
//		
//		}];
//		return nil;
//	}] doCompleted:^{
//		_syncOp = nil;
//	}].replayLazily;
//		
//
//	
//	
//	return _syncOp;
//}

@end
