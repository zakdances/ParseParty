//
//  ParseParty.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPParser.h"
#import "PPOperation.h"
#import <OMPromises/OMPromises.h>
#import <MGit-Objective-C/MGit.h>

@interface ParseParty ()

//@property	PPStatus		status;
// Utility property to get weak reference to self.
// TODO: This should be a method with an easy getter.
//@property (weak) ParseParty *weak;

@property (strong) OMDeferred *runQueueDeferred;
@property (strong) OMPromise *runQueue;

@end

@implementation ParseParty

- (id)init
{
    self = [super init];
    if (self) {
		
//        _postflightProcessingQueue = [NSOperationQueue new];
//		_requestQueue.maxConcurrentOperationCount = 1;
//		[_requests setSuspended:YES];
//		_opsQueue = [NSMutableArray array];
//		_opsQueueState = @"ready";
		self.runQueueDeferred	= [OMDeferred deferred];
		self.runQueue			= self.runQueueDeferred.promise;
		
		NSUInteger c = 10;
		self.opsQueue1 = [NSMutableArray arrayWithCapacity:c];
		self.opsQueue2 = [NSMutableArray arrayWithCapacity:c];
		self.opsQueue3 = [NSMutableArray arrayWithCapacity:c];
		self.opsQueue4 = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

+ (ParseParty *)parser
{
	PPCodeMirror *codeMirror = [[PPCodeMirror alloc] initWithFrame:CGRectMake(0, 0, 200, 200) frameName:@"CodeMirror" groupName:@"ParseParty"];
	ParseParty *parser = [self parserWithCodeMirror:codeMirror];
	
	return parser;
}

+ (ParseParty *)parserWithCodeMirror:(PPCodeMirror *)codeMirror
{
//	@synchronized(self) {
	ParseParty *parser = [ParseParty new];
		
//	parser.codeMirror			= codeMirror;
	parser.engine					= (id)codeMirror;
		
	codeMirror.interfaceDelegate	= (id<PPParseInterface,PPPostflightEngine,PPDelegate>)parser;
	
	return parser;
//	}
}

//+ (ParseParty *)sharedParser
//{
////	static ParseParty *sharedParser;
//	
//	ParseParty *sharedParser = [self sharedParserWithCodeMirror:nil];
//	
//	if (!sharedParser.codeMirror) {
//		NSLog(@"you should NOT see this...");
//		sharedParser.codeMirror = [[PPCodeMirror alloc] initWithFrame:CGRectMake(0, 0, 100, 100) frameName:@"CodeMirror" groupName:@"ParseParty"];
////		sharedParser.codeMirror.loadDelegate = sharedParser;
////		sharedParser.codeMirror.actionDelegate = sharedParser;
//	}
//	
//	return sharedParser;
//}

//+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror
//{
//	static ParseParty *sharedParser;
//	
//	@synchronized(self)
//	{
//		if (!sharedParser)
//			sharedParser = [ParseParty new];
//		
//		if (codeMirror) {
//			sharedParser.codeMirror = codeMirror;
//			codeMirror.statusDelegate = sharedParser;
//			
//			SEL selector = NSSelectorFromString(@"setParseEngine:");
//			if ([sharedParser respondsToSelector:selector]) {
//				[sharedParser performSelector:selector withObject:codeMirror];
//			}
//
//		}
//		
//		return sharedParser;
//	}
//}

//- (PPCodeMirrorWindow *)makeCodeMirrorWindow
//{
//	PPCodeMirrorWindow *cmWindow = [[PPCodeMirrorWindow alloc] initWithContentRect:CGRectMake(200, 200, 200, 200) styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
//	
//	((NSView *)cmWindow.contentView).autoresizesSubviews = YES;
//	cmWindow.title = @"CodeMirror";
//	cmWindow.codeMirror = self.codeMirror;
//	
//	self.codeMirror.frame				= [cmWindow.contentView frame];
//	self.codeMirror.autoresizingMask	= NSViewWidthSizable | NSViewHeightSizable;
//	
//	[cmWindow.contentView addSubview:self.codeMirror];
//	
//	return cmWindow;
//}

//- (__weak ParseParty *)weak
//{
//	__weak ParseParty *_self = self;
//	return _self;
//}
//
//- (void)setWeak:(__weak ParseParty *)weak {}
//- (void)changeOpsStatusTo:(NSString *)string
//{
//	OMDeferred *stateD = _opsQueueStateD;
////	OMPromise *stateP = _opsQueueStateP;
//	
//	_opsQueueStateD = [OMDeferred deferred];
//	_opsQueueStateP = [_opsQueueStateD.promise then:^id(NSString *result) {
//		_opsQueueState = result;
//		return result;
//	}];
//
//	[stateD fulfil:string];
//}

//- (void)beginRequest
//{
//	self.opsQueuePaused = YES;
//	_shouldCollectForCompoundRequest = YES;

//	PPOperation *op = [PPOperation operation];
//	
//	__weak PPOperation *weakOp = op;
//	
//	op.postflight = ^(PPOperationProcessedResponse finished) {
//		__strong PPOperation *strongOp = weakOp;
//		finished(strongOp.postflightData);
//	};
//	
//	_compoundOp = op;
	
//	[self changeOpsStatusTo:@"paused"];
//	^(ParseParty *strongSelf) {
//		
//		id (^op)(id) = ^id(id result) {
//			if (strongSelf.runQueue.state != OMPromiseStateUnfulfilled) {
//				strongSelf.runQueueDeferred = [OMDeferred deferred];
//				strongSelf.runQueue = strongSelf.runQueueDeferred.promise;
//			}
//			return nil;
//		};
//
//		[strongSelf addOp:op];
//	}(self);
//}


//- (void)endRequest:(PPCompoundResponse)compoundResponse
//{
//	if (compoundResponse) {
//
//		NSMutableArray *promises = [NSMutableArray array];
//		for (PPOperation *op in _opsQueue) {
//			
//			if (!op.running) {
//				[promises addObject:op.done];
//			}
//		}
//
//		if (promises.count > 0) {
//			[[OMPromise all:promises] then:^id(NSArray *results) {
//				return nil;
//			}];
//		}
//	}

//	[self changeOpsStatusTo:@"ready"];
//	_opsQueuePaused = NO;
//	if (self.runQueue.state == OMPromiseStateUnfulfilled && self.status != PPStatusUnloaded) {
//		OMDeferred *d = self.runQueueDeferred;
//		self.runQueue = [OMPromise promiseWithResult:@(YES)];
//		[d fulfil:@(YES)];
//	}
//}








//- (void)addRequest:(PPOperation *)__op
//{
//	if ([_opsQueue containsObject:__op]) return;
//	__weak PPOperation *op = __op;
////	PPOperation *lastOp = _opsQueue.count > 0 ? _opsQueue.lastObject : nil;
//	PPOperation *lastOp = _opsQueue.count > 0 ? _opsQueue.lastObject : nil;
//	OMPromise *lastOpDone = lastOp ? lastOp.done : [OMPromise promiseWithResult:nil];
//	[_opsQueue addObject:__op];
//
//
//	
//
////	Wait until last op is done and ParseParty isn't paused.
////	TODO: The whole chain probably shouldn't fail if one op fails...
//	if (op.commit && lastOp.commit && [op.commit.id isEqual:lastOp.commit.id]) {
//		lastOpDone = [lastOpDone failed:^(NSError *error) {
//			[op.postflightDataDeferred fail:error];
////			[op.doneDeferred fail:error];
//		}];
//	}
//	else {
//		lastOpDone = [lastOpDone rescue:^id(NSError *error) {
//			return nil;
//		}];
//	}
//
//	
//	OMDeferred *queueReady = [OMDeferred deferred];
//	
//	[lastOpDone then:^id(id result) {
//		[[self statePromiseForState:@"ready"] then:^id(id result) {
//			[queueReady fulfil:nil];
//			return nil;
//		}];
//		return nil;
//	}];
////	OMDeferred *ready2 = [OMDeferred deferred];
//
//	
//	[[queueReady.promise then:^id(id result) {
//		op.running = YES;
//		return nil;
//	}] then:^id(id result) {
//
////		OMPromise *startOp = [OMPromise promiseWithResult:nil];
//
//		BOOL needsRequest = op.preflight ? YES : NO;
//		if (needsRequest) {
//			
//			NSLog(@"queue count: %@", @(_opsQueue.count));
//			
//			PPOperation *currentOp			= op;
//			NSMutableArray *preflightData	= [NSMutableArray array];
//
//			
//			
//			
//			OMDeferred *requestData = [OMDeferred deferred];
//			
//			
////			Loop through pending ops to create an efficient, batched request.
//			NSUInteger opIndex = [_opsQueue indexOfObject:op];
//			
//			[_opsQueue enumerateObjectsUsingBlock:^(PPOperation *op, NSUInteger idx, BOOL *stop) {
//				if (idx < opIndex) return;
//				NSDictionary *_preflightData = nil;
//				
////				Filtering out any op that doesn't have a preflight property or is already running.
//				if (![op isEqual:currentOp]) {
//					if ( !op.preflight || op.running ) {
//						*stop = YES;
//						return;
//					}
//					else {
//						_preflightData = op.preflight();
//						if (!_preflightData || [_preflightData[@"type"] isEqualToString:preflightData[0][@"type"]]) {
//							*stop = YES;
//							return;
//						}
//					}
//				}
//				else {
//					_preflightData = op.preflight();
//				}
//				
//				
//				op.preflight = nil;
//				
////				Chain the request data promise with the postflight deferred
//				OMDeferred *oldPostflightDataDeferred	= op.postflightDataDeferred;
//				op.postflightDataDeferred				= [OMDeferred deferred];
//				
//				[[[OMPromise all:@[requestData.promise, op.postflightDataDeferred.promise]] then:^id(id result) {
////					NSLog(@"calling back Op...");
//					[oldPostflightDataDeferred fulfil:result[0]];
//					return nil;
//				}] failed:^(NSError *error) {
//					[oldPostflightDataDeferred fail:error];
//				}];
//				
//				
//				[preflightData addObject:_preflightData];
////				[ops addObject:op];
//
//			}];
//			
//			
//
//			
////			OMDeferred *startRequest = [OMDeferred deferred];
////			[startRequest.promise then:^id(NSArray *preflightData) {
//				
////				Make request to engine
//				[[[self.engine request:preflightData] then:^id(id result) {
//					NSLog(@"SUCCESS SUCCESS SUCESS");
//					[requestData fulfil:result];
//					return nil;
//				}] failed:^(NSError *error) {
//					NSLog(@"FAILURE FAILURE FAILURE");
//					[requestData fail:error];
//				}];
//				
////				return nil;
////			}];
////			[startRequest fulfil:preflightData];
//		}
//		
//		
//		
//		[op.postflightDataDeferred fulfil:nil];
//		
//
////		TODO: Why is this returning flattened data?
//		[[op.postflightData then:^id(id result) {
//			NSLog(@"addRequest: Got some postflightData!!! %@", op._scratchPad ? : @"(unnamed op)");
//
////			[result then:^id(id result) {
//			[op.interfaceCallbackDeferred fulfil:result];
//
//			return nil;
//		}] failed:^(NSError *error) {
//			[op.interfaceCallbackDeferred fail:error];
//		}];
//		
//		
//		
//		
////		[processedData.promise then:^id(id result) {
////			[op.interfaceCallbackDeferred fulfil:result];
////			return nil;
////		}];
//		
//		
//		return nil;
//	
//	}];
//	
//	
//
//	
//	
////	Interface done. Trigger the call back.
//	[[op.interfaceCallback then:^id(id result) {
//		[op.doneDeferred fulfil:result];
//		return nil;
//	}] failed:^(NSError *error) {
//		[op.doneDeferred fail:error];
//	}];
//
//	
//	
//	
//	
//	[[op.done then:^id(id result) {
//		[_opsQueue removeObject:op];
//		return nil;
//	}] failed:^(NSError *error) {
//		[_opsQueue removeObject:op];
//	}];
//	[dependencies addObject:ready];
	
//	[ready then:^id(NSArray *results) {
//		
////		NSDictionary *dataToProcess = results.lastObject;
//		
//		
//		return nil;
//	}];
	
//	[self runOp:_opsQueue.firstObject fromQueue:_opsQueue];
//}


//- (OMPromise *)statePromiseForState:(NSString *)state
//{
//	__weak ParseParty	*weakSelf	= self;
//
//	OMPromise *p = nil;
//	NSLog(@"state promise 1...");
//	if ([_opsQueueState isEqualToString:state]) p = [OMPromise promiseWithResult:_opsQueueState];
//	else {
//		p = [_opsQueueStateP then:^id(NSString *_state) {
//			
//			__strong ParseParty	*strongSelf	= weakSelf;
//
//			return [strongSelf statePromiseForState:state];
//		}];
//	}
//	NSLog(@"state promise 2...");
//	return p;
//}

//- (void)_statePromiseForState:(NSString *)state
//{
//	OMDeferred *deferred = [OMDeferred deferred];
//	
//	[_opsQueueState then:^id(NSString *state) {
//		
//		if ([state isEqualToString:@"paused"]) {
//			
//		}
//		else if ([state isEqualToString:@"ready"]) {
//			
//		}
//		return state;
//	}];
//	
//
//}
//- (void)tokenize:(NSString *)string mode:(NSString *)mode response:(PPTokenizeResponse)response
//{
//	PPTokenizeOperation *op = [PPTokenizeOperation operation];
//	op.prerequestString = string;
//	op.mode = mode;
//	op.responseCallback = response;
//	[self addRequest:op];
//}

- (void)addOp:(id(^)(id))op
{
	^(ParseParty *strongSelf) {
		
		[self.opsQueue2 addObject:^id(id result) {
			
			return [strongSelf.runQueue then:^id(id _result) {
				return op(result);
			}];
		}];

//		[strongSelf.runQueue then:^id(id result) {
		
		
		NSArray *arr = self.opsQueue2.copy;
		OMDeferred *d = [OMDeferred deferred];
		OMPromise *p = [d.promise then:^id(id result) {
			return [OMPromise chain:arr initial:nil];
		}];
		
		[self.opsQueue2 removeAllObjects];
		NSLog(@"got this far 2.6 should NOT be empty... %@", arr);
		[self.opsQueue2 addObject:^id(id result) {
			return p;
		}];
		

		[d fulfil:nil];

//		return nil;
//		}];
		
	}(self);
}



- (void)tokenize:(NSString *)string mode:(NSString *)mode response:(PPTokenizeResponse)response
{
//	if (self.status != PPStatusReady) @throw[self.class statusException];
//	
//	PPOperation *op = [PPOperation operation];
//	__weak PPOperation	*weakOp		= op;
//	__weak ParseParty	*weakSelf	= self;
//	
//	^{
//		__strong PPOperation *strongOp = weakOp;
//		__strong ParseParty *strongSelf = weakSelf;
//		
//		weakOp.preflight = ^{
//			return [strongSelf.engine preflightTokenize:string mode:mode];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//		
//		weakOp.postflightData = [weakOp.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf.engine postflightTokenize:postflightData response:^(NSArray *tokens, NSError *error) {
//				NSDictionary *processedData = @{@"tokens":tokens};
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//			response(processedData[@"tokens"], nil);
//			
//			return nil;
//		}];
//		
//		[weakOp.interfaceCallback failed:^(NSError *error) {
//			response(nil, error);
//		}];
//		
////		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
////			response(processedData[@"tokens"], nil);
////		};
//	}();
//	
//	[self addRequest:op];
}


- (void)parserStatusDidChangeTo:(PPStatus)newStatus from:(PPStatus)oldStatus parser:(ParseParty *)parser
{
	if (newStatus != oldStatus) {
		
		if (newStatus == PPStatusReady && oldStatus == PPStatusUnloaded) {
//			if (self.runQueue.state == OMPromiseStateUnfulfilled && self.status != PPStatusUnloaded) {
			OMDeferred *d = self.runQueueDeferred;
			self.runQueue = [OMPromise promiseWithResult:@(YES)];
			[d fulfil:@(YES)];
//			}
		}

		self.status = newStatus;
		if ([self.delegate respondsToSelector:@selector(parserStatusDidChangeTo:from:parser:)]) {
			[self.delegate parserStatusDidChangeTo:newStatus from:oldStatus parser:self];
		}
	}
}


//
//- (OMPromise *)lastOp
//{
//	return _lastOp ? : [OMPromise promiseWithResult:nil];
//}
//
//- (void)setLastOp:(OMPromise *)lastOp
//{
//	_lastOp = lastOp;
//}
//
//- (OMPromise *)lastRequest
//{
//	return _lastRequest ? : [OMPromise promiseWithResult:nil];
//}
//
//- (void)setLastRequest:(OMPromise *)lastRequest
//{
//	_lastRequest = lastRequest;
//}



+ (NSException *)statusException
{
	return [NSException exceptionWithName:@"ParseParty Status Error" reason:@"ParseParty is currently busy with another request" userInfo:nil];
}

+ (NSString *)statusToString:(PPStatus)status
{
	NSString *string = nil;
	if (status == PPStatusUnloaded) {
		string = @"unloaded";
	}
	else if (status == PPStatusReady) {
		string = @"ready";
	}
	else if (status == PPStatusBusy) {
		string = @"busy";
	}
	
	return string;
}

@end
