//
//  PPCodeMirror.m
//  ParseParty
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPCodeMirror.h"
#import "PPCodeMirror+Parse.h"

#import <CocoaPlus/WebView+Plus.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <StandardPaths/StandardPaths.h>
#import <sys/xattr.h>

//#import "ParseParty/ParseParty.h"


@interface PPCodeMirror ()

@property					PPStatus		status;
@property (strong)			WebViewJavascriptBridge *webViewbridge;

@end

@implementation PPCodeMirror

- (id)init
{
    self = [super init];
    if (self) {
//        _requests = [NSOperationQueue new];
//		_requests.maxConcurrentOperationCount = 1;
//		[_requests setSuspended:YES];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame frameName:(NSString *)frameName groupName:(NSString *)groupName
{
    self = [super initWithFrame:frame frameName:(NSString *)frameName groupName:(NSString *)groupName];
    if (self) {
        // Initialization code here.
//        NSLog(@"CM from frame %@ %@", self, self.identifier);
//		[self loadMe];
        
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
//	NSLog(@"CM from nib %@ %@", self, self.identifier);
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
	
	DOMHTMLElement *view	= [dummyWV newDivTagWithID:nil classes:@[@"ng-view"] innerHTML:nil];
	NSString *fullContents	= [NSString stringWithFormat:@"<!DOCTYPE html>%@", dummyWV.outerHTML];
	
	[dummyWV.bodyTag appendChild:view];
	// TODO: Figure out why evaluateWebScript: doesn't work.
	
	
	
	
	
	
	
	
	
	NSString *newHtmlPath = [fm pathForOfflineFile:@"pp-index.html"];
	
	[fullContents writeToFile:newHtmlPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	
	
	
	
	self.mainFrameURL = newHtmlPath;
	
	
	
	
	
	
	self.webViewbridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback callback) {
		
		NSLog(@"from CM: %@", data);
		PPStatus status = self.status;
		if (status == PPStatusUnloaded) {
			self.status = PPStatusReady;
		}


		if (status != self.status) {
			if ([self.statusDelegate respondsToSelector:@selector(parserStatusDidChangeTo:from:parser:)]) {
				[self.statusDelegate parserStatusDidChangeTo:self.status from:status parser:nil];
			}
		}
	}];
	
	[self.webViewbridge registerHandler:@"action" handler:^(id _data, WVJBResponseCallback callback) {
		
		NSMutableDictionary	*data		= [_data mutableCopy];
//		NSDictionary		*parseData	= data[@"parseData"];
		
		self.docLength = [data[@"docLength"] unsignedIntegerValue];
		
//		SEL selector = NSSelectorFromString(@"processParseData:");
//		if (parseData && [self respondsToSelector:selector]) {
//			
//			[self performSelector:selector withObject:parseData];
//			
//		}
		
		
		// Callback back to JS
		callback(@{ @"message": @(YES) });
		

		// Callback to delegate
		if ([self.statusDelegate respondsToSelector:@selector(parserDocDidChange:parser:)]) {

			[self.statusDelegate parserDocDidChange:data parser:(ParseParty *)self.statusDelegate];
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

		BOOL isStale;
		NSError *error;
		[self bookmarkIsStale:bookmarkData isStale:&isStale error:&error];
		if (isStale == YES) NSLog(@"Bookmark is stale :(");
		[errors addObject:error];
		
		
		NSDictionary *values = [NSURL resourceValuesForKeys:@[NSURLPathKey] fromBookmarkData:bookmarkData];
		resolvedFileURL = [NSURL fileURLWithPath:values[NSURLPathKey]];
		
	}
	
	for (NSError *error in errors) {
		NSLog(@"alias error: %@", error.localizedDescription);
	}

	return resolvedFileURL;
}

- (NSURL *)bookmarkIsStale:(NSData *)bookmarkData isStale:(BOOL *)isStale error:(NSError **)error
{
//	NSURL *bURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:isStale error:error];
	return [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:isStale error:error];
}





//- (NSDictionary *)preflight:(PPTokenizeOperation *)request
//{
////	NSDictionary *data = @{ @"string": string,
////							@"mode": mode };
////	
////	[self.webViewbridge callHandler:@"tokenize" data:data responseCallback:^(id responseData) {
////		NSLog(@"tokenized!");
////		NSDictionary *newData = responseData;
////		
////		NSArray *tokens = newData[@"tokens"];
////		
////		tokensBlock(tokens);
////	}];
//	
//}

- (NSDictionary *)preflightTokenize:(NSString *)stringToTokenize
{
	NSMutableDictionary *requestData = @{@"requestName":@"tokenize"}.mutableCopy;
	requestData[@"string"] = stringToTokenize;
	return requestData;
}

- (BOOL)postflightTokenize:(id)responseData response:(PPTokenizeResponse)response
{
	NSDictionary	*data		= [self.class requestDataNamed:@"tokenize" fromResponseData:responseData];
	NSArray		*tokens		= data[@"tokens"];
	response(tokens);
	return YES;
}


- (void)request:(NSArray *)requestData response:(PPEngineResponse)response
{
//	NSMutableArray *requestsJSON = [NSMutableArray array];
//	
//	for (PPOperation *request in requests) {
//		[requestsJSON addObject:[request toJSON]];
//	}
	NSLog(@"Here we go...");
	NSDictionary *data = @{@"requests":requestData};
	
	[self.webViewbridge callHandler:@"request" data:data responseCallback:^(NSDictionary *data) {
//		NSLog(@"tokenized!");
//		NSDictionary *newData = responseData;
//		NSArray *tokens = data[@"tokens"];
//		
//		tokensBlock(tokens);
		response(data);
	}];
}

+ (NSDictionary *)requestDataNamed:(NSString *)requestName fromResponseData:(NSDictionary *)responseData
{
	NSArray *requests = responseData[@"requests"];
	for (NSDictionary *requestData in requests) {
		NSString *requestName = requestData[@"requestName"];
		if ([requestName isEqualToString:requestName]) {
			return requestData;
		}
	}
	return nil;
}
//- (void)compoundRequest:(NSArray *)requestsData
//{
//	
//}

@end
