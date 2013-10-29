//
//  cdCodeMirror.h
//  Codesaur
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "PPProtocols.h"
//#import "cdRepository.h"
@class WebViewJavascriptBridge;
@class cdCommit;

typedef NS_ENUM(NSInteger, PPCodeMirrorStatus) {
    PPCodeMirrorStatusUnloaded,
    PPCodeMirrorStatusReady,
	PPCodeMirrorStatusBusy
};





//@interface PPCodeMirror : WebView <syncOpProvider> {
@interface PPCodeMirror : WebView <PPTokenize>

//@property (strong,readonly)	cdRepository			*contentRepo;

@property (readonly)		PPCodeMirrorStatus		status;
@property (strong,readonly) WebViewJavascriptBridge *webViewbridge;
@property (weak) id			<PPLoadDelegate> loadDelegate;
@property (weak) id			<PPActionDelegate> actionDelegate;

@property NSUInteger docLength;
//@property (weak) DOMHTMLElement *headTag;
//@property (weak) DOMHTMLElement *bodyTag;

//@property (strong) WebViewPlus *dummyWV;
//@property (strong,readonly)	RACSignal *codeMirrorDidSend;
//@property (strong,readonly) RACSignal *codeMirrorDidEditWithChangeSignal;

//- (void)appendTagToHead:(NSString *)tagName InnerHTML:(NSString *)innerHTML;
//- (void)appendTagToBody:(NSString *)tagName InnerHTML:(NSString *)innerHTML;
//- (RACSignal *)syncOp:(cdCommit *)changeToSync lastSelfChange:(cdCommit *)lastSelfChange;

@end
