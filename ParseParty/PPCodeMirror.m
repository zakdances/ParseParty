//
//  PPCodeMirror.m
//  ParseParty
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPCodeMirror.h"
#import "PPCodeMirror+Parse.h"
#import "PPOperation.h"

#import <CocoaPlus/WebView+Plus.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <StandardPaths/StandardPaths.h>
#import <sys/xattr.h>

#import <Jantle/Jantle.h>
#import <OMPromises/OMPromises.h>
#import "jNSValueWithRange.h"
//#import "ParseParty/ParseParty.h"


@interface PPCodeMirror ()

//@property PPStatus		status;
@property (strong)	WebViewJavascriptBridge *webViewbridge;
@property (strong) NSMutableArray *resources;

//@property (strong) NSArray *selectedRanges;

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
	self.resources = [NSMutableArray array];

	NSBundle *bb = [self bundleInMainBundleNamed:@"PPBowerBundle"];
	NSBundle *cmb = [self bundleInMainBundleNamed:@"PPCodeMirrorBundle"];
	NSBundle *mgb = [self bundleInMainBundleNamed:@"PPMGitBundle"];
	NSBundle *ab = [self bundleInMainBundleNamed:@"PPAppBundle"];
	NSBundle *cb = [self bundleInMainBundleNamed:@"PPControllersBundle"];
	NSBundle *db = [self bundleInMainBundleNamed:@"PPDirectivesBundle"];
	NSBundle *sb = [self bundleInMainBundleNamed:@"PPServicesBundle"];
	
	NSString *bDir = @"bower_components";
	NSString *cmDir = @"CodeMirror";
	NSString *mgDir = @"MGit";
	NSString *aDir = @"app";
	NSString *cDir = @"controllers";
	NSString *dDir = @"directives";
	NSString *sDir = @"services";
	
	NSArray *fileTypes = @[@"css",@"js",@"map"];
	
	
	[self addDataForResource:@"jquery.js"		dirName:bDir inBundle:bb];
//	[self addDataForResource:@"underscore.js"	dirName:bDir inBundle:bb];
	
	[self addDataForResource:@"codemirror.js"	dirName:cmDir inBundle:cmb];
	
	[self addDataForResource:@"angular.js"				dirName:bDir inBundle:bb];
	[self addDataForResource:@"angular-route.js"		dirName:bDir inBundle:bb];
	[self addDataForResource:@"jquery.color.js"			dirName:bDir inBundle:bb];
	[self addDataForResource:@"CSRange.js"				dirName:bDir inBundle:bb];
	
	[self addDataForResource:@"codemirror.css"		dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"runmode.js"			dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"css.js"				dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"sass.js"				dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"less.js"				dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"closebrackets.js"	dirName:cmDir inBundle:cmb];
	[self addDataForResource:@"matchbrackets.js"	dirName:cmDir inBundle:cmb];
	
	
	for (NSString *fileType in fileTypes) {
		NSBundle *bundle = mgb;
		for (NSURL *fileURL in [bundle URLsForResourcesWithExtension:fileType subdirectory:nil]) {
			[self addDataForResource:fileURL.lastPathComponent dirName:mgDir inBundle:bundle];
		}
	}
	
	for (NSString *fileType in fileTypes) {
		NSBundle *bundle = ab;
		for (NSURL *fileURL in [bundle URLsForResourcesWithExtension:fileType subdirectory:nil]) {
			[self addDataForResource:fileURL.lastPathComponent dirName:aDir inBundle:bundle];
		}
	}
	
	for (NSString *fileType in fileTypes) {
		NSBundle *bundle = cb;
		for (NSURL *fileURL in [bundle URLsForResourcesWithExtension:fileType subdirectory:nil]) {
			[self addDataForResource:fileURL.lastPathComponent dirName:cDir inBundle:bundle];
		}
	}
	
	for (NSString *fileType in fileTypes) {
		NSBundle *bundle = db;
		for (NSURL *fileURL in [bundle URLsForResourcesWithExtension:fileType subdirectory:nil]) {
			[self addDataForResource:fileURL.lastPathComponent dirName:dDir inBundle:bundle];
		}
	}
	
	for (NSString *fileType in fileTypes) {
		NSBundle *bundle = sb;
		for (NSURL *fileURL in [bundle URLsForResourcesWithExtension:fileType subdirectory:nil]) {
			[self addDataForResource:fileURL.lastPathComponent dirName:sDir inBundle:bundle];
		}
	}

//	NSArray *resourceData = @[
//							  
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPBowerBundle"],
//								 @"directoryName": @"bower_components",
//								 @"resources":
//									 @[@"jquery.js",
//									   @"underscore.js",
//									   @"angular.js",
//									   @"angular-route.js",
//									   @"jquery.color.js",
//									   @"CSRange.js",
//									   @"CSAttributedString.js"] }.mutableCopy,
//							  
////							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPUnderscoreBundle"],
////								 @"resources": @[@"underscore.js"] },
//							  
//							  // CodeMirror________
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPCodeMirrorBundle"],
//								 @"directoryName": @"CodeMirror",
//								 @"resources":
//									 @[
//										 @"codemirror.css",
//										 @"codemirror.js",
//										 @"runmode.js",
//										 @"css.js",
//										 @"sass.js",
//										 @"less.js",
//										 @"closebrackets.js",
//										 @"matchbrackets.js"
//									   ]
//								 }.mutableCopy,
//							  //__________________
//							  
//
//							  
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPAppBundle"],
//								 @"directoryName": @"app",
//								 @"resources": @(YES) }.mutableCopy,
//							  
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPControllersBundle"],
//								 @"directoryName": @"controllers",
//								 @"resources": @(YES) }.mutableCopy,
//							  
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPDirectivesBundle"],
//								 @"directoryName": @"directives",
//								 @"resources": @(YES) }.mutableCopy,
//							  
//							  @{ @"bundle": [self bundleInMainBundleNamed:@"PPServicesBundle"],
//								 @"directoryName": @"services",
//								 @"resources": @(YES) }.mutableCopy,
//							  
//							  ];
	
	
	
//	NSMutableArray *allResourcePaths = [NSMutableArray array];
	NSMutableArray *resourceTags = [NSMutableArray array];
	
	
	NSFileManager *fm	= [NSFileManager new];
	fm.delegate			= self;

	WebView *dummyWV = [WebView webViewWithBlankPage];
	[dummyWV.htmlTag setAttribute:@"ng-app" value:@"ParsePartyApp"];
	
	[self deleteContentsOfDirectory:[NSURL fileURLWithPath:fm.offlineDataPath] withFileManager:fm];
	
	for (NSMutableDictionary *data in self.resources) {
		
		NSURL	*resourceURL	= data[@"resourceURL"];
		NSString	*directoryName	= data[@"directoryName"];
		

		NSURL *newFileURL = [[[NSURL fileURLWithPath:fm.offlineDataPath]
								  URLByAppendingPathComponent:directoryName isDirectory:YES]
								  URLByAppendingPathComponent:resourceURL.lastPathComponent];
		
		[self replaceItemAtURL:newFileURL withItemAtURL:resourceURL usingFileManager:fm];
		
		
		// Apply new tag to dummy webview.
		DOMHTMLElement *tag = nil;
		NSString *tagValue = [NSString stringWithFormat:@"%@/%@",directoryName,newFileURL.lastPathComponent];
		
		if ([resourceURL.pathExtension isEqualToString:@"css"]) {
			tag = [dummyWV newLinkStylesheetTag:tagValue];
		} else if ([resourceURL.pathExtension isEqualToString:@"js"]) {
			tag = [dummyWV newScriptTag:tagValue];
		}
		
		if (tag) [resourceTags addObject:tag];


	}
	
	
	for (DOMHTMLElement *tag in resourceTags) {
		[dummyWV.headTag appendChild:tag];
	}

	
	

	
	DOMHTMLElement *view	= [dummyWV newDivTagWithID:nil classes:@[@"ng-view"] innerHTML:nil];
	
	[dummyWV.bodyTag appendChild:view];
	// TODO: Figure out why evaluateWebScript: doesn't work.
	
	
	
	
	
	
	
	NSString *htmlString	= [NSString stringWithFormat:@"<!DOCTYPE html>%@", dummyWV.outerHTML];
	
	NSURL *newHtmlURL = [NSURL fileURLWithPath:[fm pathForOfflineFile:@"pp-index.html"]];
	
	NSError *error;
	[htmlString writeToURL:newHtmlURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (error) NSLog(@"%@", error.localizedDescription);
	
	
	
	
	self.mainFrameURL = newHtmlURL.path;
//	self.mainFrameURL = @"https://google.com";
	
	
	
	
	
	self.webViewbridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback callback) {
		
		NSLog(@"from CM: %@", data);
		
		PPStatus status = self.status;
		if (status == PPStatusUnloaded && [data isEqualToString:@"readyy"]) {
			[[OMPromise promiseWithResult:nil after:1] then:^id(id result) {
				self.status = PPStatusReady;
				return nil;
			}];
		}


//		if (status != self.status) {
//			if ([self.statusDelegate respondsToSelector:@selector(parserStatusDidChangeTo:from:parser:)]) {
//				[self.statusDelegate parserStatusDidChangeTo:self.status from:status parser:nil];
//			}
//		}
	}];
	
	[self.webViewbridge registerHandler:@"action" handler:^(id rawData, WVJBResponseCallback callback) {
		
//		NSMutableDictionary	*processedData		= [NSMutableDictionary dictionary];
//
//
//		NSMutableArray *selectedRanges		= [NSMutableArray array];
//		NSMutableArray *oldSelectedRanges	= nil;
//		
////		NSMutableDictionary *rangeData = nil;
//
//
//		for (id key in rawData) {
//			id val = rawData[key];
//			
//			if ([key isEqualToString:@"selectedRanges"]) {
//				
//				NSMutableDictionary *selectedRangesData = [NSMutableDictionary dictionary];
//				for (id key in val) {
//					id _val = val[key];
//					
//						
//					NSMutableArray *ranges = nil;
//					if ([key isEqualToString:@"ranges"] && val != [NSNull null]) {
//						ranges = selectedRanges;
//					}
//					else if ([key isEqualToString:@"oldRanges"] && val != [NSNull null]) {
//						oldSelectedRanges = [NSMutableArray array];
//						ranges = oldSelectedRanges;
//					}
//					
//					if (ranges) {
//						for (NSDictionary *rangeData in _val) {
//							
//							NSError *error;
//							NSValue *valueWithRange = [NSValue fromJSON:rangeData modelOfClass:jNSValueWithRangeAndDirection.class error:&error];
//							if (error) NSLog(@"%@", error.localizedDescription);
//							
//							[ranges addObject:valueWithRange];
//						}
//						_val = ranges;
//					}
//					selectedRangesData[key] = _val;
//				}
//				
//				val = selectedRangesData;
//			}
//			
//			
//			processedData[key] = val;
//		}

		
		
		
		
		// Callback to delegate for doc length change
//		if ([self.interfaceDelegate respondsToSelector:@selector(parserDocDidChange:parser:)]) {
//			[self.interfaceDelegate parserDocDidChange:processedData parser:nil];
//		}
		NSArray *opsData = rawData[@"requests"];
		
		for (NSDictionary *opData in opsData) {
			
			NSString *type = opData[@"type"];
//			NSDictionary *opData = [self.class requestDataNamed:type fromResponseData:rawData];
			
			PPOperation *op = [PPOperation operation];
			
//			op.preflight = nil;
//			OMPromise *_rawDataPromise = [OMPromise promiseWithResult:rawData];

			
			__weak PPOperation *weakOp = op;
			__weak PPCodeMirror *weakSelf = self;
			^{
				__strong PPOperation *strongOp = weakOp;
				__strong PPCodeMirror *strongSelf = weakSelf;
				
//				OMDeferred *deferred = [OMDeferred deferred];
//				weakOp.postflightData = deferred.promise;
//				
//				OMPromise *rawDataPromise = [[OMPromise all:@[[OMPromise promiseWithResult:rawData], weakOp.postflightDataDeferred.promise]] then:^id(id result) {
//					return result[0];
//				}];
//				
//				
//				
//
//				if ([type isEqualToString:@"range"]) {
//					
//					NSString *stringKey = @"string";
//					NSString *oldStringKey = @"oldString";
//					NSString *rangeKey = @"range";
//					
////					weakOp.postflightData = deferred.promise;
//					
//					[rawDataPromise then:^id(NSDictionary *postflightData) {
//						
//						[strongSelf.interfaceDelegate postflightRange:postflightData response:^(NSString *string, NSString *oldString, NSRange range, NSError *error) {
//							
//							NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//							processedData[stringKey] = string;
//							processedData[rangeKey] = [NSValue valueWithRange:range];
//							if (oldString) processedData[oldStringKey] = oldString;
//							
//							[deferred fulfil:processedData];
//						}];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//						NSString *string = processedData[stringKey];
//						NSString *oldString = processedData[oldStringKey];
//						NSRange range = [processedData[rangeKey] rangeValue];
//						
//						[strongSelf.interfaceDelegate parserDidChangeRange:range toString:string fromString:oldString parser:nil error:nil];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback failed:^(NSError *error) {
//						[strongSelf.interfaceDelegate parserDidChangeRange:NSMakeRange(NSNotFound, NSNotFound) toString:nil fromString:nil parser:nil error:error];
//					}];
////					weakOP.interfaceCallback = ^(NSDictionary *processedData) {
////						NSString *string = processedData[stringKey];
////						NSString *oldString = processedData[oldStringKey];
////						NSRange range = [processedData[rangeKey] rangeValue];
////						
////						
////							[strongSelf.interfaceDelegate parserDidChangeRange:range toString:string fromString:oldString parser:nil];
////					
////					};
//				}
//				
//				if ([type isEqualToString:@"selectedRanges"]) {
//					
//					NSString *rangesKey = @"ranges";
//					NSString *oldRangesKey = @"oldRanges";
//					
//					[rawDataPromise then:^id(NSDictionary *postflightData) {
//					
//						[strongSelf.interfaceDelegate postflightSelectedRanges:postflightData response:^(NSArray *ranges, NSArray *oldRanges, NSError *error) {
//							
//							NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//							processedData[rangesKey] = ranges;
//							processedData[oldRangesKey] = oldRanges;
//							
//							[deferred fulfil:processedData];
//						}];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//						NSArray *ranges = processedData[rangesKey];
//						NSArray *oldRanges = processedData[oldRangesKey];
//						
//						[strongSelf.interfaceDelegate parserDidChangeSelectedRangesTo:ranges from:oldRanges parser:nil error:nil];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback failed:^(NSError *error) {
//						[strongSelf.interfaceDelegate parserDidChangeSelectedRangesTo:nil from:nil parser:nil error:error];
//					}];
//					
////					weakOp.interfaceCallback = ^(NSDictionary *processedData) {
////						NSArray *ranges = processedData[rangesKey];
////						NSArray *oldRanges = processedData[oldRangesKey];
////						
////						
////							[strongSelf.interfaceDelegate parserDidChangeSelectedRangesTo:ranges from:oldRanges parser:nil];
////						
////					};
//				}
//				
//				if ([type isEqualToString:@"parse"]) {
//					
//					NSString *tokensKey = @"tokens";
//					NSString *rangeKey = @"range";
//					
//					[rawDataPromise then:^id(NSDictionary *postflightData) {
//						
//						[strongSelf.interfaceDelegate postflightParseRange:postflightData response:^(NSArray *tokens, NSRange range, NSError *error) {
//							
//							NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//							processedData[tokensKey] = tokens;
//							processedData[rangeKey] = [NSValue valueWithRange:range];
//							
////							strongOP.postflightData = @{tokensKey: tokens,
////														rangeKey: [NSValue valueWithRange:range]};
////							finished(strongOP.postflightData);
//							[deferred fulfil:processedData];
//						}];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//						NSArray *tokens = processedData[tokensKey];
//						NSRange range = [processedData[rangeKey] rangeValue];
//						
//						[strongSelf.interfaceDelegate parserDidParse:range tokens:tokens parser:nil error:nil];
//						
//						return nil;
//					}];
//					
//					[weakOp.interfaceCallback failed:^(NSError *error) {
//						[strongSelf.interfaceDelegate parserDidParse:NSMakeRange(NSNotFound, NSNotFound) tokens:nil parser:nil error:error];
//					}];
					
//					weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//						NSArray *tokens = processedData[tokensKey];
//						NSRange range = [processedData[rangeKey] rangeValue];
//						
//						
//							[strongSelf.interfaceDelegate parserDidParse:range tokens:tokens parser:nil];
//						
//					};
//				}
			}();
			
		
//			[self.interfaceDelegate addRequest:op];
//			if ([type isEqualToString:@"range"]) {
//				
//
//				
//				__weak PPCodeMirror *weakSelf = self;
//				[self.interfaceDelegate postflightRange:rawData response:^(NSString *string, NSString *oldString, NSRange range) {
//					
//					__strong PPCodeMirror *strongSelf = weakSelf;
//					if ([strongSelf.interfaceDelegate respondsToSelector:@selector(parserDidChangeRange:toString:fromString:parser:)]) {
//						[strongSelf.interfaceDelegate parserDidChangeRange:range toString:string fromString:oldString parser:nil];
//					}
//				}];
//				
//		
//	
//			}
//			
//	
//			else if ([type isEqualToString:@"parse"]) {
//				
//				__weak PPCodeMirror *weakSelf = self;
//				[self.interfaceDelegate postflightParseRange:rawData response:^(NSArray *tokens, NSRange range) {
//					
//					__strong PPCodeMirror *strongSelf = weakSelf;
//					if ([strongSelf.interfaceDelegate respondsToSelector:@selector(parserDidParse:tokens:parser:)]) {
//						[strongSelf.interfaceDelegate parserDidParse:range tokens:tokens parser:nil];
//					}
//				}];
//			}
//			
//			
//
//			else if ([type isEqualToString:@"selectedRanges"]) {
//				
//				
//				__weak PPCodeMirror *weakSelf = self;
//				[self.interfaceDelegate postflightSelectedRanges:rawData response:^(NSArray *selectedRanges, NSArray *oldSelectedRanges) {
//					
//					__strong PPCodeMirror *strongSelf = weakSelf;
//					if ([strongSelf.interfaceDelegate respondsToSelector:@selector(parserDidChangeSelectedRangesTo:from:parser:)]) {
//						[strongSelf.interfaceDelegate parserDidChangeSelectedRangesTo:selectedRanges from:oldSelectedRanges parser:nil];
//					}
//				}];
//				
//
//			}
		}
		
		// Callback back to JS
		callback(@(YES));
		
		
	}];
}


- (NSBundle *)bundleInMainBundleNamed:(NSString *)bundleName
{
	return [NSBundle bundleWithPath:[[NSBundle mainBundle]
					pathForResource:bundleName
							 ofType:@"bundle"]];
}

//- (NSMutableDictionary *)dataForResource:(NSString *)fileName bundleName:(NSString *)bundleName dirName:(NSString *)dirName
//{
//	return @{ @"bundleName": bundleName,
//			  @"bundle": [self bundleInMainBundleNamed:bundleName],
//			  @"directoryName": dirName,
//			  @"resources": @[fileName] }.mutableCopy;
//}

- (void)addDataForResource:(NSString *)fileName dirName:(NSString *)dirName inBundle:(NSBundle *)bundle
{
	NSMutableDictionary *data = @{ @"bundleName": bundle.bundleURL.lastPathComponent,
								   @"bundle": bundle,
								   @"directoryName": dirName,
								   @"resource": fileName,
								   @"resourceURL": [bundle URLForResource:fileName.stringByDeletingPathExtension withExtension:fileName.pathExtension]}.mutableCopy;
	
	[self addResource:data];
}

- (void)addResource:(NSDictionary *)resourceData
{
	NSDictionary *dupe = nil;
	for (NSDictionary *_rd in self.resources) {
		if ([_rd[@"resource"] isEqualToString:resourceData[@"resource"]]
			&& [_rd[@"directoryName"] isEqualToString:resourceData[@"directoryName"]]) {
			dupe = _rd;
		}
	}
	
	if (!dupe) {
		[self.resources addObject:resourceData];
	}
}

//- (NSMutableDictionary *)dataaForAllResourcesIn:(NSString *)bundleName dirName:(NSString *)dirName
//{
//	NSBundle *bundle = [self bundleInMainBundleNamed:bundleName];
//	
//	NSMutableArray *allFileNames = [NSMutableArray array];
//	NSMutableArray *allFileURLs = [NSMutableArray array];
//	
//	for (NSString *fileExtension in @[@"css",@"js",@"map"]) {
//		NSArray *urls = [bundle URLsForResourcesWithExtension:fileExtension subdirectory:nil];
//		[allFileURLs addObjectsFromArray:urls];
//		for (NSURL *url in urls) {
//			[allFileNames addObject:url.lastPathComponent];
//		}
//	}
//	return @{ @"bundleName": bundleName,
//			  @"bundle": bundle,
//			  @"directoryName": dirName,
//			  @"resources": allFileNames }.mutableCopy;
//}



- (void)replaceItemAtURL:(NSURL *)replaceeURL withItemAtURL:(NSURL *)replacerURL usingFileManager:(NSFileManager *)fm
{
//	NSMutableArray *errors  = [NSMutableArray array];
//	NSLog(@"replaccee URL: %@", replaceeURL);
	
	replacerURL = [self fileURLByResolvingAlias:replacerURL] ? : replacerURL;
//	NSString *replacerPath = replacerURL.path;
	
	BOOL isDir = YES;
	BOOL dirExists = [fm fileExistsAtPath:replaceeURL.URLByDeletingLastPathComponent.path isDirectory:&isDir];
	if (!dirExists) {
		NSError *error;
		[fm createDirectoryAtURL:replaceeURL.URLByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:&error];
		if (error) NSLog(@"dirExists: %@", error.localizedDescription);
	}
	
	
	
	BOOL fileExists = [fm fileExistsAtPath:replaceeURL.path];
	if (!fileExists) {
		// Copy file to temp directory
		NSError *error;
		[fm copyItemAtURL:replacerURL toURL:replaceeURL error:&error];
		if (error) NSLog(@"fileExists: %@", error.localizedDescription);
	}
	else {
	
		// Choose temp directory path
		NSURL *tempDirURL = [NSURL fileURLWithPath:[fm pathForTemporaryFile:[[NSUUID UUID] UUIDString]] isDirectory:YES];
//		NSLog(@"tempDirURL: %@", tempDirURL);
		
		// Create temp directory
//		BOOL isDir2 = YES;
//		if ([fm fileExistsAtPath:tempDirURL.path isDirectory:&isDir2]) {
//			NSError *error05;
//			[fm removeItemAtURL:tempDirURL error:&error05];
//			if (error05) NSLog(@"%@", error05.localizedDescription);
//		}
		NSError *error1;
		[fm createDirectoryAtURL:tempDirURL withIntermediateDirectories:NO attributes:nil error:&error1];
		if (error1) NSLog(@"%@", error1.localizedDescription);


		// Copy file to temp directory
		NSError *error2;
		[fm copyItemAtURL:replacerURL toURL:[tempDirURL URLByAppendingPathComponent:replacerURL.lastPathComponent] error:&error2];
		if (error2) NSLog(@"2: %@", error2.localizedDescription);
		
		
		// Replace from temp directory to new dir
		NSError* error3;
		[fm replaceItemAtURL:replaceeURL withItemAtURL:[tempDirURL URLByAppendingPathComponent:replaceeURL.lastPathComponent] backupItemName:[NSString stringWithFormat:@"_%@", replaceeURL.lastPathComponent] options:0 resultingItemURL:nil error:&error3];
		if (error3) NSLog(@"3: %@", error3.localizedDescription);
			


		// Delete temp directory
		NSError *error4;
		[fm removeItemAtURL:tempDirURL error:&error4];
		if (error4) NSLog(@"%@", error4.localizedDescription);
		
	//	for (NSError *error in errors) {
	//		NSLog(@"replaceItem error: %@", error.localizedDescription);
	//	}
	}

}

- (NSURL *)fileURLByResolvingAlias:(NSURL *)aliasURL
{
	NSMutableArray *errors = [NSMutableArray array];
	NSURL *resolvedFileURL = nil;
	
	NSError *error14;
	NSData *bookmarkData = [NSURL bookmarkDataWithContentsOfURL:aliasURL error:&error14];
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








- (void)deleteContentsOfDirectory:(NSURL *)directory withFileManager:(NSFileManager *)fm
{
	BOOL isDir = YES;
	BOOL dirExists = [fm fileExistsAtPath:directory.path isDirectory:&isDir];
	if (dirExists && isDir) {
		
//		NSError *error;
//		[fm createDirectoryAtURL:replaceeURL.URLByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:error1];
//		if (error) NSLog(@"dirExists: %@", error.localizedDescription);
		NSError *error;
		NSArray *fileNames = [fm contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:0 error:&error];
		if (error) NSLog(@"%@", error.localizedDescription);
		
		for (NSURL *fileURL in fileNames) {
			NSError *error4;
			[fm removeItemAtURL:fileURL error:&error4];
			if (error4) NSLog(@"%@", error4.localizedDescription);
		}
//		NSLog(@"Contents of %@ has been deleted.", directory);
	}
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

- (NSDictionary *)preflightTokenize:(NSString *)string mode:(NSString *)mode
{
	NSMutableDictionary *requestData = @{@"type":@"tokenize"}.mutableCopy;
	requestData[@"string"] = string;
	return requestData;
}

- (BOOL)postflightTokenize:(id)responseData response:(PPTokenizeResponse)response
{
	NSDictionary	*data		= [self.class requestDataNamed:@"tokenize" fromResponseData:responseData];
	NSArray		*tokens		= data[@"tokens"];
	response(tokens, nil);
	return YES;
}




- (NSArray *)request:(NSArray *)opJSON
{
	[self setStatus:PPStatusBusy];
	
	NSUInteger preflightOpCount = opJSON.count;
	
	NSMutableArray *deferreds = [NSMutableArray array];
	NSMutableArray *promises = [NSMutableArray array];
	
	for (int i = 0; i < preflightOpCount; i++) {
		OMDeferred *d = [OMDeferred deferred];
		[deferreds addObject:d];
		[promises addObject:d.promise];
	};

	
	^(PPCodeMirror *strongSelf) {
		[[OMPromise all:opJSON] then:^id(NSArray *result) {
			
			NSDictionary *data = @{@"requests":result};
			
			[strongSelf.webViewbridge callHandler:@"request" data:data responseCallback:^(NSDictionary *data) {

				//		NSDictionary *newData = responseData;
				NSArray *rqs = [data isKindOfClass:NSDictionary.class] ? data[@"requests"] : nil;
				//
				//		tokensBlock(tokens);
				//		NSLog(@"Request finished! Passing back data... %@", data);
				if (!rqs || rqs.count != preflightOpCount) {
					NSLog(@"PPCodeMirror request: There was an error!!! Sending back info...");
					
					NSString *errorString = [data isKindOfClass:NSString.class] ? (NSString *)data : @"ERROR: Invalid data: %@";
					NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}];
					
					for (OMDeferred *d in deferreds) {
						[d fail:error];
					}
				}
				else {
					for (int i = 0; i < deferreds.count; i++) {
						NSDictionary *postflightJSON = rqs[i];
						[deferreds[i] fulfil:postflightJSON];
					};
				}
				
				//		response(data);
				[strongSelf setStatus:PPStatusReady];
			}];
			
			return nil;
		}];
	}(self);

	
	
	
	return promises;
}





+ (NSDictionary *)requestDataNamed:(NSString *)type fromResponseData:(NSDictionary *)responseData
{
	
	NSArray *requests = responseData[@"requests"];
	for (NSDictionary *requestData in requests) {

		if ([requestData[@"type"] isEqualToString:type]) {
			return requestData;
		}
	}
	return nil;
}

- (PPStatus)status
{
	return _status;
}
- (void)setStatus:(PPStatus)status
{
	PPStatus currentStatus = _status;
	if (currentStatus != status) {

//		TODO: Send KVO notifications
		_status = status;
		if ([self.interfaceDelegate respondsToSelector:@selector(parserStatusDidChangeTo:from:parser:)]) {
			[self.interfaceDelegate parserStatusDidChangeTo:_status from:currentStatus parser:nil];
		}

	}
}

@end
