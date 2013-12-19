//
//  ParseParty.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

//#import "ParseParty/ParseParty+Parse.h"

#import "PPBasicProtocols.h"
#import "PPCodeMirror.h"
#import "PPCodeMirrorWindow.h"
#import "PPParseProtocol.h"

#import "PPRuleSet.h"
@class PPOperation;
@class OMDeferred;
@class OMPromise;

@interface ParseParty : NSObject <PPTokenizeInterface> {
	
	// These are the operations with actually communication with the WebView. Requests should have one of these as their dependency.
//	__strong OMPromise		*_lastOp;
//	__strong NSDictionary		*_lastRequest;

//	__strong NSString *_opsQueueState;
//	__strong OMDeferred *_opsQueueStateD;
//	__strong OMPromise *_opsQueueStateP;
//	BOOL _shouldCollectForCompoundRequest;
//	__strong PPOperation *_compoundOp;

//	__strong NSOperationQueue *_postflightProcessingQueue;
//	__strong Deferred *_mainRequest;
}

//@property (weak) PPCodeMirror *codeMirror;
@property (strong) id <PPTokenizeEngine,PPParseEngine,PPPostflightEngine> engine;
@property (weak) id <PPDelegate> delegate;
@property PPStatus status;

@property (strong,readonly) OMDeferred *runQueueDeferred;
@property (strong,readonly) OMPromise *runQueue;
//@property (strong) OMPromise *lastOp;
//@property (strong) NSDictionary *lastRequest;
@property (strong) NSMutableArray *opsQueue1;
@property (strong) NSMutableArray *opsQueue2;
@property (strong) NSMutableArray *opsQueue3;
@property (strong) NSHashTable *opsQueue4;
// This might no be needed, but it's used for thread safety.
@property (strong) NSMutableArray *opsThatNeedRequest;

+ (ParseParty *)parser;
+ (ParseParty *)parserWithCodeMirror:(PPCodeMirror *)codeMirror;
//+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror;
//- (PPCodeMirrorWindow *)makeCodeMirrorWindow;

//- (void)beginRequest;
//- (void)endRequest:(PPCompoundResponse)compoundResponse;
// This should be private.
//- (void)addRequest:(PPOperation *)request;

- (OMPromise *)statePromiseForState:(NSString *)state;




+ (NSException *)statusException;

+ (NSString *)statusToString:(PPStatus)status;

@end
