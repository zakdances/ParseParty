//
//  cdCodeMirror.h
//  Codesaur
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "PPTokenizeProtocol.h"
#import "PPParseProtocol.h"
//#import "cdRepository.h"
@class WebViewJavascriptBridge;
@class cdCommit;

//typedef NS_ENUM(NSUInteger, PPCodeMirrorStatus) {
//    PPCodeMirrorStatusUnloaded,
//    PPCodeMirrorStatusReady,
//	PPCodeMirrorStatusBusy
//};





//@interface PPCodeMirror : WebView <syncOpProvider> {
@interface PPCodeMirror : WebView <PPTokenizeEngine> {
		PPStatus _status;
}

//@property (strong,readonly)	cdRepository			*contentRepo;

@property (readonly)		PPStatus		status;
@property (strong,readonly) WebViewJavascriptBridge *webViewbridge;
//@property (weak) id			<PPStatusDelegate> statusDelegate;
@property (weak) id			<PPParseInterface,PPPostflightEngine,PPDelegate> interfaceDelegate;
@property (strong,readonly) NSMutableArray *resources;

//@property NSUInteger docLength;
//@property (strong,readonly) NSArray *selectedRanges;
//@property (weak) DOMHTMLElement *headTag;
//@property (weak) DOMHTMLElement *bodyTag;

//@property (strong) WebViewPlus *dummyWV;
//@property (strong,readonly)	RACSignal *codeMirrorDidSend;
//@property (strong,readonly) RACSignal *codeMirrorDidEditWithChangeSignal;

//- (void)appendTagToHead:(NSString *)tagName InnerHTML:(NSString *)innerHTML;
//- (void)appendTagToBody:(NSString *)tagName InnerHTML:(NSString *)innerHTML;
//- (RACSignal *)syncOp:(cdCommit *)changeToSync lastSelfChange:(cdCommit *)lastSelfChange;

// Utility function to help find request data from JSON response.
+ (NSDictionary *)requestDataNamed:(NSString *)type fromResponseData:(NSDictionary *)responseData;

@end
