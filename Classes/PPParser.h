//
//  ParseParty.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

#import "ParseParty/ParseParty+Parse.h"

#import "PPProtocols.h"
#import "PPCodeMirror.h"
#import "PPCodeMirrorWindow.h"
#import "PPParseProtocol.h"
#import "PPTokenizeOperation.h"

#import "PPRule.h"


@interface ParseParty : NSObject <PPTokenizeInterface, PPStatusDelegate> {
	BOOL _shouldCollectMultipleRequests;
	// These are the operations with actually communication with the WebView. Requests should have one of these as their dependency.
	__strong NSMutableArray		*_pendingRequests;
	__strong NSOperationQueue	*_postflightProcessingQueue;
//	__strong Deferred *_mainRequest;
}

@property (weak) PPCodeMirror *codeMirror;
@property (weak) id <PPStatusDelegate> statusDelegate;
@property (readonly) PPStatus status;

@property (strong) id <PPTokenizeEngine,PPParseEngine,PPRequestProtocol> engine;

+ (ParseParty *)parser;
+ (ParseParty *)parserWithCodeMirror:(PPCodeMirror *)codeMirror;
//+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror;
- (PPCodeMirrorWindow *)makeCodeMirrorWindow;

- (void)beginRequest;
- (void)endRequest:(PPCompoundResponse)compoundResponse;

// This should be private.
- (void)addRequest:(PPOperation *)request;

@end
