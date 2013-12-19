//
//  ParseParty+Parse.m
//  Pods
//
//  Created by Zak.
//
//

//#import "ParseParty.h"

#import "ParseParty+Parse.h"
#import "PPCodeMirror+Parse.h"
#import "PPOperation.h"


#import "jNSValueWithRange.h"
#import <Jantle/Jantle.h>
#import <OMPromises/OMPromises.h>
#import <MGit-Objective-C/MGit.h>
#import <objc/objc-runtime.h>

//static void *preflightJSONKey;
//static void *opTypeKey;

//@interface OMPromise (stuff)
//
//@property (strong) NSString *type;
//@property (strong) NSMutableArray *preflightJSON;
//
//@end
//
//@implementation OMPromise (stuff)
//
//- (NSMutableArray *)preflightJSON
//{
//	return objc_getAssociatedObject(self, preflightJSONKey);
//}
//
//- (void)setPreflightJSON:(NSMutableArray *)preflightJSON
//{
//	objc_setAssociatedObject(self, preflightJSONKey, preflightJSON, OBJC_ASSOCIATION_RETAIN);
//}
//
//- (NSString *)type
//{
//	return objc_getAssociatedObject(self, opTypeKey);
//}
//
//- (void)setType:(NSString *)type
//{
//	objc_setAssociatedObject(self, opTypeKey, type, OBJC_ASSOCIATION_RETAIN);
//}
//
//@end

@implementation ParseParty (Parse)

- (void)mode:(NSString *)mode response:(PPModeResponse)response
{
//	PPOperation *op = [PPOperation operation];
//	op._scratchPad = @"modeOp";
//	__weak PPOperation *weakOp = op;
//	__weak ParseParty *weakSelf = self;
	
	^(ParseParty *strongSelf){
		
//		__strong PPOperation *strongOp = weakOp;
//		__strong ParseParty *strongSelf = weakSelf;
		
//		OMPromise *lastOp = self.opsQueue.allObjects.lastObject;

//		OMPromise *preflightJSON = ^OMPromise *(OMDeferred *d) {
//			
//			[strongSelf.engine modeAdapterToJSON:^(PPPreflightModeProcessing3 cb) {
//				[d fulfil:cb(mode)];
//			} fromJSON:nil];
//			
//			return d.promise;
//			
//		}([OMDeferred deferred]);
		

//		OMPromise *postFlightJSON = [strongSelf addRequestOp:preflightJSON];
//		[self.opsQueue1 addObject:^id(id result) {
			
		OMPromise *preflightJSON = ^OMPromise * (OMDeferred *d) {
			//			First format preflight JSON...
			[self.engine modeAdapterToJSON:^(PPPreflightModeProcessing3 cb) {
				[cb(mode) then:^id(id result) {
					[d fulfil:result];
					return nil;
				}];
			} fromJSON:nil];
				
			return d.promise;
				
		}([OMDeferred deferred]);
//		}];
		
		OMPromise *postflightJSON = [strongSelf addRequestOp:preflightJSON];
		
		[self addOp:^id(id result) {
	
			OMDeferred *d = [OMDeferred deferred];
			
			[strongSelf.engine modeAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPModeResponse)) {

				[a(postflightJSON, ^(NSString *mode, NSString *fromMode, NSError *e) {
					if (response) response(mode, fromMode, e);
				}) then:^id(id result) {

					[d fulfil:result];
					return nil;
				}];
				
			}];
			
			return d.promise;
		}];
		
	}(self);
//		^id(NSDictionary *postflightJSON) {
//			
//		}(nil);
	
//			then:^id(NSDictionary *json) {
//				
//			NSDictionary *request = ^NSDictionary *(NSMutableArray *newJSONOps) {
//				
//				NSDictionary	*request			= strongSelf.opsQueue.allObjects.lastObject;
//				NSMutableArray	*jsonOps			= request ? request[@"jsonOps"] : nil;
//				OMPromise		*processedData		= request ? request[@"processedData"] : nil;
//				
//				BOOL shouldMakeNewRequest = ^BOOL () {
//					__block BOOL b = YES;
//					if (!request || processedData.progress > 0) return b;
//					[jsonOps enumerateObjectsUsingBlock:^(NSDictionary *_preD, NSUInteger idx, BOOL *stop) {
//						//					if (lastRQ.progress > 0) *stop = YES;
//						if ([newJSONOps.firstObject[@"type"] isEqualToString:_preD[@"type"]]) *stop = YES;
//						else if (idx == jsonOps.count - 1) b = NO;
//					}];
//					return b;
//				}();
//	
////				if (!shouldMakeNewRequest) {
////					[strongSelf.lastRequest[@"jsonOps"] addObject:newJSONOps.firstObject];
////					return strongSelf.lastRequest;
////				}
//				if (!shouldMakeNewRequest) {
//					request =
//						@{ @"jsonOps": newJSONOps,
//	//						TODO: When this runs, it might not be the last op any more...
//						@"processedData"		: [[lastOp then:^id(id result) {
//							return [strongSelf statePromiseForState:@"ready"];
//						}] then:^id(id result) {
//							OMDeferred *d = [OMDeferred deferred];
//							[d progress:.5];
//							[[OMPromise all:[strongSelf.engine request:newJSONOps]] then:^id(NSArray *processedData) {
//								[d fulfil:processedData];
//								return nil;
//							}];
//							return d.promise;
//						}]};
//					
//					strongSelf.lastRequest = request;
//				}
//				else {
//					[jsonOps addObjectsFromArray:newJSONOps];
//				}
//
//				
//				return request;
//
//			}(@[json].mutableCopy);
//				
////				strongSelf.lastRequest	= newRequest ;
////			NSMutableArray *jsonOps		= request[@"jsonOps"];
//			NSUInteger index = [request[@"jsonOps"] indexOfObject:json];
//			OMPromise *processedData	= [request[@"processedData"] then:^id(NSArray *processedData) {
//				return processedData[index];
//			}];
//			
//			return processedData;
//		}]
									 
		
		
//			return d.promise;
//		}];
//		strongSelf.lastOp = pfp;
		
		
//		[[OMPromise all:@[d.promise, strongSelf.lastRequest]] then:^id(NSArray *rd) {
//			
//			__block BOOL shouldBatchMe = NO;
//			NSArray *allPreD = (rd[1] != NSNull.null ? rd[1][0] : @[]);
//			[allPreD enumerateObjectsUsingBlock:^(NSDictionary *preD, NSUInteger idx, BOOL *stop) {
//				if ([preD[@"type"] isEqualToString:rd[0][@"type"]]) *stop = YES;
//				else if (idx == allPreD.count - 1) shouldBatchMe = YES;
//			}];
//			
//			
//			if (shouldBatchMe) {
//				[rd[1][0] addObject:rd[0]];
//			}
//			else {
//				strongSelf.lastRequest = [OMPromise all:@[ @[rd[0]], [OMPromise all:[strongSelf.engine request:@[]]] ] ];
//				
//			}
////			for (NSDictionary *preD in rd[1] != NSNull.null ? rd[1][0] : @[]) {
////				if ([preD[@"type"] isEqualToString:rd[0][@"type"] ]) {
//////					shouldBatchMe = NO;
////					break;
////				}
////				
////			}
//			return nil;
//		}];
//		
//		weakOp.preflight = ^{
//			return [strongSelf.engine preflightMode:mode];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//		
//		weakOp.postflightData = [weakOp.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf.engine postflightMode:postflightData response:^(NSString *mode, NSString *fromMode, NSError *error) {
//				
//				NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//				processedData[@"mode"] = mode;
//				if (fromMode) processedData[@"fromMode"] = fromMode;
//
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//
//		
//		
//		[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSString *mode		= processedData[@"mode"];
//			NSString *fromMode	= processedData[@"fromMode"];
//
//			if (response) response(mode, fromMode, nil);
//			
//			return nil;
//		}];
//		
//		[weakOp.interfaceCallback failed:^(NSError *error) {
//			if (response) response(nil, nil, error);
//		}];
//		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//			NSString *mode		= processedData[@"mode"];
//			NSString *fromMode	= processedData[@"fromMode"];
//			
//			if (response) response(mode, fromMode);
//
//		};
	
	
//	[self addRequest:op];
}

//- (void)cursorLocation:(NSUInteger)location response:(PPCursorLocationResponse)response
//{
//	PPOperation *op = [PPOperation operation];
//	__weak PPOperation *weakOp = op;
//	__weak ParseParty *weakSelf = self;
//	
//	^{
//		__strong PPOperation *strongOp = weakOp;
//		__strong ParseParty *strongSelf = weakSelf;
//		
//		weakOp.preflight = ^{
//			return [strongSelf.engine preflightCursorLocation:location];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//
//		weakOp.postflightData = [weakOp.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf.engine postflightCursorLocation:postflightData response:^(NSUInteger location, NSError *error) {
//				if (error) return [deferred fail:error];
//				
//				NSDictionary *processedData = @{@"location": @(location)};
//				
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSUInteger location = [processedData[@"location"] unsignedIntegerValue];
//			if (response) response(location, nil);
//			
//			return processedData;
//		}];
//		
//		[weakOp.interfaceCallback failed:^(NSError *error) {
//			if (response) response(NSNotFound, error);
//		}];
////		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
////
////				if (response) response([processedData[@"location"] unsignedIntegerValue]);
////			
////		};
//	}();
//	
//	[self addRequest:op];
//}

- (void)selectedRanges:(NSArray *)selectedRanges commit:(MGITCommit *)commit response:(PPSelectedRangesResponse)response
{
//	PPOperation *op = [PPOperation operation];
//	commit = commit ? commit : [MGITCommit commit];
	
//	__weak ParseParty *weakSelf = self;
	
	^{
		
		
	}();
//		__strong PPOperation *strongOp = weakOp;
//		__strong ParseParty *strongSelf = weakSelf;
		
		
//		[[[strongSelf addRequestOp:^OMPromise * (OMDeferred *d) {
//			//			First format preflight JSON...
//			[strongSelf.engine selectedRangesAdapterToJSON:^(PPPreflightSelectedRangesProcessing3 cb) {
//				[d fulfil:cb(selectedRanges, commit)];
//			} fromJSON:nil];
//			return d.promise;
//			
//		}([OMDeferred deferred])] then:^id(id result) {
//			return [[strongSelf lastOp] then:^id(id _result) {
//				return result;
//			}];
//		}] then:^id(NSDictionary *postflightJSON) {
//			//			...then serialize postflight JSON back to objects and call callbacks.
//
//			return ^OMPromise * (OMDeferred *d) {
//				
//				[strongSelf.engine selectedRangesAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPSelectedRangesResponse)) {
//					[d fulfil:a(postflightJSON, ^(NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *e) {
//						if (response) response(selectedRanges, oldSelectedRanges, commit, e);
//						[strongSelf parserDidChangeSelectedRangesTo:selectedRanges from:oldSelectedRanges commit:commit parser:strongSelf error:e];
//					})];
//				}];
//				return d;
//				
//			}([OMDeferred deferred]);
//		}];
		
		
//		op.preflight = ^{
//			return [strongSelf.engine preflightSelectedRanges:selectedRanges commit:commit];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//
//		op.postflightData = [op.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf postflightSelectedRanges:postflightData response:^(NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *error) {
//				if (error) return [deferred fail:error];
//				
//				NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//				processedData[@"ranges"] = selectedRanges;
//				processedData[@"oldRanges"] = oldSelectedRanges;
//				processedData[@"commit"] = commit;
////				if (error) processedData[@"error"] = error;
// 
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[op.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSArray *ranges = processedData[@"ranges"];
//			NSArray *oldRanges = processedData[@"oldRanges"];
//			MGITCommit *commit = processedData[@"commit"];
//			
//			if (response) response(ranges, oldRanges, commit, nil);
//			[strongSelf parserDidChangeSelectedRangesTo:ranges from:oldRanges commit:commit parser:strongSelf error:nil];
//			
//			return processedData;
//		}];
//		
//		[op.interfaceCallback failed:^(NSError *error) {
//			if (response) response(nil, nil, commit, error);
//			[strongSelf parserDidChangeSelectedRangesTo:nil from:nil commit:commit parser:strongSelf error:error];
//		}];
		
//		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//			
//			NSArray *ranges = processedData[@"ranges"];
//			NSArray *oldRanges = processedData[@"oldRanges"];
//			
//			
//			if (response) response(ranges, oldRanges);
//			[strongSelf parserDidChangeSelectedRangesTo:ranges from:oldRanges parser:strongSelf];
//		
//		};
	
	
//	[self addRequest:op];
}

- (void)parseRange:(NSRange)range commit:(MGITCommit *)commit response:(PPParseResponse)response
{
//	PPOperation *op = [PPOperation operation];
//	commit = commit ? commit : [MGITCommit commit];

//	__weak PPOperation *weakOp = op;
	__weak ParseParty *weakSelf = self;
	^{
//		__strong PPOperation *strongOp = weakOp;
		__strong ParseParty *strongSelf = weakSelf;
		
//		[[[strongSelf addRequestOp:^OMPromise * (OMDeferred *d) {
//			//			First format preflight JSON...
//			[strongSelf.engine parseRangeAdapterToJSON:^(PPPreflightParseProcessing3 cb) {
//				[d fulfil:cb(range, commit)];
//			} fromJSON:nil];
//			return d.promise;
//			
//		}([OMDeferred deferred])] then:^id(id result) {
//			return [[strongSelf lastOp] then:^id(id _result) {
//				return result;
//			}];
//		}] then:^id(NSDictionary *postflightJSON) {
//			//			...then serialize postflight JSON back to objects and call callbacks.
//			
//			return ^OMPromise * (OMDeferred *d) {
//				[strongSelf.opsQueue addObject:d.promise];
//				
//				[strongSelf.engine parseRangeAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPParseResponse)) {
//					[d fulfil:a(postflightJSON, ^(NSArray *tokens, NSRange range, MGITCommit *commit, NSError *e) {
//						if (response) response(tokens, range, commit, e);
//						[strongSelf parserDidParse:range tokens:tokens commit:commit parser:self error:e];
//					})];
//				}];
//				
//				return d;
//				
//			}([OMDeferred deferred]);
//		}];
		
//		op.preflight = ^{
//			return [strongSelf.engine preflightParseRange:range commit:commit];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//		
//		op.postflightData = [op.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf postflightParseRange:postflightData response:^(NSArray *tokens, NSRange range, MGITCommit *commit, NSError *error) {
//				if (error) return [deferred fail:error];
//				
//				NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//				processedData[@"tokens"] = tokens;
//				processedData[@"range"] = [NSValue valueWithRange:range];
//				processedData[@"commit"] = commit;
//				
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[[op.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSArray *tokens = processedData[@"tokens"];
//			NSRange range = [processedData[@"range"] rangeValue];
//			MGITCommit *commit = processedData[@"commit"];
//			
//			if (response) response(tokens, range, commit, nil);
//			[strongSelf parserDidParse:range tokens:tokens commit:commit parser:strongSelf error:nil];
//			return nil;
//			
//		}] failed:^(NSError *error) {
//			NSRange nilRange = NSMakeRange(NSNotFound, NSNotFound);
//			if (response) response(nil, nilRange, commit, error);
//			[strongSelf parserDidParse:nilRange tokens:nil commit:commit parser:strongSelf error:error];
//		}];
		
//		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//			NSArray *tokens = processedData[@"tokens"];
//			NSRange range = [processedData[@"range"] rangeValue];
//			
//			
//				if (response) response(tokens, range);
//				[strongSelf parserDidParse:range tokens:tokens parser:strongSelf];
//			
//		};
	}();
	
//	[self addRequest:op];
}

- (void)range:(NSRange)range string:(NSString *)string commit:(MGITCommit *)commit response:(PPRangeResponse)response
{
//	PPOperation *op = [PPOperation operation];
//	commit = commit ? commit : [MGITCommit commit];
	
//	op._scratchPad = @"rangeOp";
//	__weak PPOperation *weakOp = op;
//	__weak ParseParty *weakSelf = self;
	
	^(ParseParty *strongSelf) {
		
		OMPromise *preflightJSON = ^OMPromise * (OMDeferred *d) {
			//			First format preflight JSON...
			[strongSelf.engine rangeAdapterToJSON:^(PPPreflightRangeProcessing3 cb) {
				[cb(range, string, commit) then:^id(id result) {
					[d fulfil:result];
					return nil;
				}];
			} fromJSON:nil];
			
			return d.promise;
			
		}([OMDeferred deferred]);
		//		}];
		
		
		OMPromise *postflightJSON = [strongSelf addRequestOp:preflightJSON];
		
		id (^op)(id) = ^id(id result) {
			
			OMDeferred *d = [OMDeferred deferred];
			[strongSelf.engine rangeAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPRangeResponse)) {
				[d fulfil:a(postflightJSON, ^(NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *e) {
					if (response) response(string, oldString, range, commit, e);
					if (oldString) [strongSelf parserDidChangeRange:range toString:string fromString:oldString commit:commit parser:strongSelf error:e];
				})];
			}];
			
			return d.promise;
		};
		
		[strongSelf addOp:op];
		
	}(self);
		
//		__strong PPOperation *strongOp = weakOp;
//		__strong ParseParty *strongSelf = weakSelf;
//		
//		[[[strongSelf addRequestOp:^OMPromise * (OMDeferred *d) {
//			//			First format preflight JSON...
//			[strongSelf.engine rangeAdapterToJSON:^(PPPreflightRangeProcessing3 cb) {
//				[d fulfil:cb(range, string, commit)];
//			} fromJSON:nil];
//			return d.promise;
//			
//		}([OMDeferred deferred])] then:^id(id result) {
//			return [[strongSelf lastOp] then:^id(id _result) {
//				return result;
//			}];
//		}] then:^id(NSDictionary *postflightJSON) {
//			//			...then serialize postflight JSON back to objects and call callbacks.
//			
//			return ^OMPromise * (OMDeferred *d) {
//				[self.opsQueue addObject:d.promise];
//				
//				[strongSelf.engine rangeAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPRangeResponse)) {
//					[d fulfil:a(postflightJSON, ^(NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *e) {
//						if (response) response(string, oldString, range, commit, e);
//						if (oldString) [strongSelf parserDidChangeRange:range toString:string fromString:oldString commit:commit parser:self error:e];
//					})];
//				}];
//				return d.promise;
//				
//			}([OMDeferred deferred]);
//		}];
		
//		op.preflight = ^{
//			return [strongSelf.engine preflightRange:range string:string commit:commit];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//		
//		op.postflightData = [op.postflightData then:^id(NSDictionary *postflightData) {
//
//			[strongSelf postflightRange:postflightData response:^(NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *error) {
//				if (error) return [deferred fail:error];
//				
//				NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
//				processedData[@"string"] = string;
//				processedData[@"range"] = [NSValue valueWithRange:range];
//				processedData[@"commit"] = commit;
//				if (oldString) processedData[@"oldString"] = oldString;
//				
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[op.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSString *string = processedData[@"string"];
//			NSString *oldString = processedData[@"oldString"];
//			NSRange range = [processedData[@"range"] rangeValue];
//			MGITCommit *commit = processedData[@"commit"];
//			
//			
//			if (response) response(string, oldString, range, commit, nil);
//			[strongSelf parserDidChangeRange:range toString:string fromString:oldString commit:commit parser:strongSelf error:nil];
//
//			return nil;
//		}];
//		
//		[op.interfaceCallback failed:^(NSError *error) {
//			NSRange nilRange = NSMakeRange(NSNotFound, NSNotFound);
//
//			if (response) response(nil, nil, nilRange, commit, error);
//			[strongSelf parserDidChangeRange:nilRange toString:nil fromString:nil parser:strongSelf error:error];
//		}];
		
//		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//			NSString *string = processedData[@"string"];
//			NSString *oldString = processedData[@"oldString"];
//			NSRange range = [processedData[@"range"] rangeValue];
//			
//			
//				if (response) response(string, oldString, range);
//				[strongSelf parserDidChangeRange:range toString:string fromString:oldString parser:strongSelf];
//			
//		};
	
	
//	[self addRequest:op];
}

- (void)docLength:(PPDocLengthResponse)response
{
//	PPOperation *op = [PPOperation operation];
	
//	__weak PPOperation *weakOp = op;
	__weak ParseParty *weakSelf = self;
	
	^{
//		__strong PPOperation *strongOp = weakOp;
		__strong ParseParty *strongSelf = weakSelf;

		
//		[[[strongSelf addRequestOp:^OMPromise * (OMDeferred *d) {
//			//			First format preflight JSON...
//			[strongSelf.engine docLengthAdapterToJSON:^(PPPreflightDocLengthProcessing3 cb) {
//				[d fulfil:cb()];
//			} fromJSON:nil];
//			return d.promise;
//			
//		}([OMDeferred deferred])] then:^id(id result) {
//			return [[strongSelf lastOp] then:^id(id _result) {
//				return result;
//			}];
//		}] then:^id(NSDictionary *postflightJSON) {
//			//			...then serialize postflight JSON back to objects and call callbacks.
//			
//			return ^OMPromise * (OMDeferred *d) {
//				[self.opsQueue addObject:d.promise];
//				
//				[strongSelf.engine docLengthAdapterToJSON:nil fromJSON:^(OMPromise * (^a)(OMPromise *, PPDocLengthResponse)) {
//					[d fulfil:a(postflightJSON, ^(NSUInteger docLength, NSError *e) {
//						if (response) response(docLength, e);
////						[strongSelf ];
//					})];
//				}];
//				return d.promise;
//				
//			}([OMDeferred deferred]);
//		}];
	
//		weakOp.preflight = ^{
//			return [strongSelf.engine preflightDocLength];
//		};
//		
//		OMDeferred *deferred = [OMDeferred deferred];
//		
//		weakOp.postflightData = [weakOp.postflightData then:^id(NSDictionary *postflightData) {
//			
//			[strongSelf.engine postflightDocLength:postflightData response:^(NSUInteger docLength, NSError *error) {
//				if (error) return [deferred fail:error];
//				
//				NSDictionary *processedData = @{@"length":@(docLength)};
//				
//				[deferred fulfil:processedData];
//			}];
//			
//			return deferred.promise;
//		}];
//		
//		[weakOp.interfaceCallback then:^id(NSDictionary *processedData) {
//			NSUInteger docLength = [processedData[@"length"] unsignedIntegerValue];
//			
//			if (response) response(docLength, nil);
//			
//			return nil;
//		}];
//		
//		[weakOp.interfaceCallback failed:^(NSError *error) {
//			if (response) response(NSNotFound, error);
//		}];
		
//		weakOp.interfaceCallback = ^(NSDictionary *processedData) {
//			NSUInteger length = [processedData[@"length"] unsignedIntegerValue];
//			
//			
//				if (response) response(length);
//			
//		};
	}();

//	[self addRequest:op];
}




//- (OMPromise *)postflight
//{
//	
//}
//
//- (BOOL)postflightRange:(id)responseData response:(PPRangeResponse)response
//{
//	[self.engine postflightRange:responseData response:^(NSString *stringJSON, NSString *oldStringJSON, NSRange rangeJSON, MGITCommit *commit, NSError *error) {
////		if (!error) {
////			response(stringJSON, oldStringJSON, rangeJSON, error);
////		}
////		else {
////			response(stringJSON, oldStringJSON, rangeJSON, error);
////		}
//		response(stringJSON, oldStringJSON, rangeJSON, commit, error);
//	}];
//
//	return YES;
//}
//
//- (BOOL)postflightSelectedRanges:(id)responseData response:(PPSelectedRangesResponse)response
//{
//	__weak ParseParty *weakSelf = self;
//	[self.engine postflightSelectedRanges:responseData response:^(NSArray *rangesJSON, NSArray *oldRangesJSON, MGITCommit *commit, NSError *error) {
//
//		if (error) return response(rangesJSON, oldRangesJSON, commit, error);
//		
//			__strong ParseParty *strongSelf = weakSelf;
//			NSArray *ranges = [strongSelf.class fromJSONToRangesWithDirections:rangesJSON];
//			NSArray *oldRanges = [strongSelf.class fromJSONToRangesWithDirections:oldRangesJSON];
//			
//			response(ranges, oldRanges, commit, error);
//
//	}];
//	return YES;
//}
//
//- (BOOL)postflightParseRange:(id)responseData response:(PPParseResponse)response
//{
//
////	__weak ParseParty *weakSelf = self;
//	
//	[self.engine postflightParseRange:responseData response:^(NSArray *tokensJSON, NSRange rangeJSON, MGITCommit *commit, NSError *error) {
//		if (error) return response(tokensJSON, rangeJSON, commit, error);
//		
////		__weak ParseParty *strongSelf = weakSelf;
//
//		NSMutableArray *mutableTokens = [NSMutableArray array];
//		[tokensJSON enumerateObjectsUsingBlock:^(NSDictionary *token, NSUInteger idx, BOOL *stop) {
//			
//			NSMutableDictionary *mutableToken = [NSMutableDictionary dictionary];
//			
//			for (id key in token) {
//				id val = token[key];
//				NSError *error;
//				
//				
//				if ([key isEqualToString:@"color"] || [key isEqualToString:NSForegroundColorAttributeName]) {
//					val = [NSColor fromJSON:val modelOfClass:jNSColor.class error:&error];
//				} else if ([val isKindOfClass:NSDictionary.class] && [[val allKeys] count] == 2 && val[@"location"] && val[@"length"]) {
//					val = [NSValue fromJSON:val modelOfClass:jNSValue.class error:&error];
//				}
//				
//				
//				if (error) NSLog(@"%@", error.localizedDescription);
//				mutableToken[key] = val;
//			}
//			
//			[mutableTokens addObject:mutableToken];
//		}];
//		
//		
//		response(mutableTokens, rangeJSON, commit, error);
//		
//
////		if ([strongSelf.delegate respondsToSelector:@selector(parserDidParse:tokens:parser:)]) {
////			[strongSelf.delegate parserDidParse:range tokens:tokens parser:nil];
////		}
//		
//	}];
//	return YES;
//}







//+ (NSArray *)fromJSONToRangesWithDirections:(NSArray *)rangesJSON
//{
//	NSMutableArray *ranges = [NSMutableArray array];
//	
//
//	for (NSDictionary *rangeData in rangesJSON) {
//		
//		NSError *error;
//		NSValue *valueWithRange = [NSValue fromJSON:rangeData modelOfClass:jNSValueWithRangeAndDirection.class error:&error];
//		if (error) NSLog(@"%@", error.localizedDescription);
//		
//		[ranges addObject:valueWithRange];
//	}
//	
//
//	return ranges;
//}


// TODO: Figure out a better way to handle JSON.
+ (NSDictionary *)rangeToJSON:(NSRange)range
{
	return @{@"location": @(range.location),
			 @"length": @(range.length)};
}

+ (NSRange)rangeFromJSON:(NSDictionary *)rangeJSON
{
	return NSMakeRange([rangeJSON[@"location"] unsignedIntegerValue], [rangeJSON[@"length"] unsignedIntegerValue]);
}

+ (NSDictionary *)rangeWithDirectionToJSON:(NSValue *)valueWithRangeWithDirection
{
	NSMutableDictionary *json = [self rangeToJSON:valueWithRangeWithDirection.rangeValue].mutableCopy;
	json[@"direction"] = valueWithRangeWithDirection.rangeDirection == NSRangeDirectionUp ? @"up" : @"down";
	return json.copy;
}

+ (NSValue *)rangeWithDirectionFromJSON:(NSDictionary *)rangeWithDirectionJSON
{
	NSRange range = [self rangeFromJSON:rangeWithDirectionJSON];
	NSValue *v = [NSValue valueWithRange:range];
	v.rangeDirection = @"up" ? NSRangeDirectionUp : NSRangeDirectionDown;
	return v;
}

+ (NSDictionary *)commitToJSON:(MGITCommit *)commit
{
	NSDictionary *d = nil;
	@try {
		d = @{@"id": commit.id.UUIDString};
	}
	@catch (NSException *exception) {
		@throw [NSException exceptionWithName:@"toJSON error" reason:@"MGITCommit was null" userInfo:nil];
	}
	return d;
}

+ (MGITCommit *)commitFromJSON:(NSDictionary *)commitJSON
{
	MGITCommit *c = nil;
	@try {
		c = [MGITCommit commitWithStringID:commitJSON[@"id"]];
		
		NSString *source = commitJSON[@"source"];
		if ([source isEqualToString:@"ParseParty"]) [c.source setSource:self strength:MGITCommitSourceStrengthWeak];
		else [c.source setSource:source strength:MGITCommitSourceStrengthStrong];
	}
	@catch (NSException *exception) {
		@throw [NSException exceptionWithName:@"commitFromJSON Error: " reason:@"JSON for MGITCommit is invalid." userInfo:nil];
	}

	return c;
}

+ (NSError *)errorFromJSON:(id)errorJSON
{
	NSString *errorString = [errorJSON isKindOfClass:NSString.class] ? (NSString *)errorJSON : [NSString stringWithFormat:@"ERROR: Invalid data: %@", errorJSON];
	NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:777 userInfo:@{NSLocalizedDescriptionKey: errorString,
																					  PPRecoveredDataKey: [NSMutableDictionary dictionary]}];

	return error;
}

+ (NSError *)errorFromJSON:(id)errorJSON recoveredData:(NSDictionary *)recoveredData
{
	NSError *error = [self errorFromJSON:errorJSON];
	[error.userInfo[PPRecoveredDataKey] addEntriesFromDictionary:recoveredData];
	
	return error;
}
//- (PPOperation *)rangeAdapterToJSON:(PPPreflightParseProcessingBox)toJSON fromJSON:(PPPostflightParseProcessing3)fromJSON
//{
//	return [operation attachToJSON:toJSON( ^OMPromise *(NSRange range, MGITCommit *commit) {
//		return [OMPromise promiseWithResult:@
//	} ) andFromJSON:nil];
//}


//- (void)parserDocDidChange:(NSDictionary *)responseData parser:(ParseParty *)parser
//{
//	if ([self.delegate respondsToSelector:@selector(parserDocDidChange:parser:)]) {
//		[self.delegate parserDocDidChange:responseData parser:self];
//	}
//}


- (OMPromise *)addRequestOp:(OMPromise *)preflightJSON
{
//	__weak ParseParty *weakSelf = self;
	OMDeferred *d1 = [OMDeferred deferred];
	OMDeferred *d2 = [OMDeferred deferred];
	
	^(ParseParty *strongSelf) {
		
		if (![preflightJSON isMemberOfClass:OMPromise.class]) {
			[preflightJSON then:^id(id result) {
	//			NSLog(@"ERROR ERROR ERROR ERROR: %@);", result);
				return nil;
			}];
		}
		[self.opsQueue1 addObject:@[preflightJSON, d1]];

	

	
		
		
//		[self.opsQueue2 addObject:];
		NSLog(@"Adding op attemptRequest...");
		[self addOp:^id(id result) { return [strongSelf attemptRequest]; }];
		NSLog(@"Adding op fulfil...");
		[self addOp:^id(id result) {
			//			  __strong ParseParty *strongSelf = weakSelf;
			[d1.promise then:^id(id result) {
				[d2 fulfil:result];
				return nil;
			}];
			return d2.promise;
		}];

//		return d2.promise;
	}(self);
	
	return d2.promise;
//	NSMutableDictionary *bucket = @{@"a": preflightJSON,
//									@"b": @(NO),
//									@"c": [OMDeferred deferred]}.mutableCopy;
//	
//	[self.opsThatNeedRequest addObject:bucket];
	
	
	
//	[self.opsQueue addObject:[self.opsQueue.allObjects.lastObject then:^id(id result) {
//		
//		return nil;
//	}]];
//
//	[preflightJSON then:^id(id result) {
//		return nil;
//	}];
	
//	OMPromise *request = ^OMPromise *(NSMutableArray *newJSONOps) {
//		
//		
//		__strong ParseParty *strongSelf = weakSelf;
//
//		OMPromise *findAlreadyExistingRequest = [[OMPromise all:^NSMutableArray *(NSMutableArray *arr) {
//				
//				[strongSelf.opsQueue.allObjects enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(OMPromise *op, NSUInteger idx, BOOL *stop) {
//					if (![op.type isEqualToString:@"request"] || op.progress > 0 || op.state != OMPromiseStateUnfulfilled) return;
//					[arr addObject:[[OMPromise all:op.preflightJSON] then:^id(NSArray *preflightData) {
//						//					if ([newJSONOps.firstObject[@"type"] isEqualToString:_preD[@"type"]])
//						return @[op, preflightData];
//					}]];
//				}]
//				return arr;
//				
//			}([NSMutableArray array])] then:^id(NSArray *arr) {
//			return ^NSArray * () {
//				
//				for (NSArray *arr in arr) {
//					if (arr[1] && [arr[1] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSArray *arr, NSDictionary *bindings) {
//						for (NSDictionary *preflightData in arr) {
//							if ([newJSONOps.firstObject[@"type"] isEqualToString:preflightData[@"type"]]) return YES;
//						}
//						return NO;
//					}]].count == 0) return @[arr[0]];
//				}
//				return nil;
//
//			}();
//		}];
//		
//		
//		[findAlreadyExistingRequest then:^id(NSArray *arr) {
//			OMPromise *request = arr && arr.count > 0 ? arr[0] : ^OMPromise *() {
//				
//				OMPromise *x = [strongSelf.opsQueue.allObjects.lastObject then:^id(id result) {
//					return nil;
//				}];
//				
//				return x;
//			}();
//			
//			
////			BOOL shouldMakeNewRequest = ^BOOL () {
////				__block BOOL b = YES;
////				if (!request || processedData.progress > 0) return b;
////				[jsonOps enumerateObjectsUsingBlock:^(NSDictionary *_preD, NSUInteger idx, BOOL *stop) {
////					//					if (lastRQ.progress > 0) *stop = YES;
////					if ([newJSONOps.firstObject[@"type"] isEqualToString:_preD[@"type"]]) *stop = YES;
////					else if (idx == jsonOps.count - 1) b = NO;
////				}];
////				return b;
////			}();
//			
//		}];
////		NSMutableArray	*jsonOps			= request ? request[@"jsonOps"] : nil;
////		OMPromise		*processedData		= request ? request[@"processedData"] : nil;
//		
//		
//		
//		//				if (!shouldMakeNewRequest) {
//		//					[strongSelf.lastRequest[@"jsonOps"] addObject:newJSONOps.firstObject];
//		//					return strongSelf.lastRequest;
//		//				}
//		if (!shouldMakeNewRequest) {
//			request =
//			@{ @"jsonOps": newJSONOps,
//			   //						TODO: When this runs, it might not be the last op any more...
//			   @"processedData"		: [[lastOp then:^id(id result) {
//				   return [strongSelf statePromiseForState:@"ready"];
//			   }] then:^id(id result) {
//				   OMDeferred *d = [OMDeferred deferred];
//				   [d progress:.5];
//				   [[OMPromise all:[strongSelf.engine request:newJSONOps]] then:^id(NSArray *processedData) {
//					   [d fulfil:processedData];
//					   return nil;
//				   }];
//				   return d.promise;
//			   }]};
//			
//			strongSelf.lastRequest = request;
//		}
//		else {
//			[jsonOps addObjectsFromArray:newJSONOps];
//		}
//		
//		
//		return processedData;
//		
//	}(@[preflightJSON].mutableCopy);
	

}


- (OMPromise *)attemptRequest
{
//	OMDeferred *d = [OMDeferred deferred];
	
//	__weak ParseParty *weakSelf = self;
	return ^OMPromise * (ParseParty *strongSelf) {
//		__strong ParseParty *strongSelf = weakSelf;
//		OMDeferred *d = [OMDeferred deferred];

		
		return [[^OMPromise * (NSArray *opsQueue1Copy) {
			
			NSMutableArray *opsQueue1MutableCopy = [NSMutableArray array];
			NSMutableArray *preflightJSONArray = [NSMutableArray array];
			
			[opsQueue1Copy enumerateObjectsUsingBlock:^(NSArray *savedOp, NSUInteger idx, BOOL *stop) {
				OMPromise *preflightJSON = savedOp[0];
				OMDeferred *d = savedOp[1];
				if (d.state == OMPromiseStateUnfulfilled && d.progress == 0) {
					[opsQueue1MutableCopy addObject:savedOp];
					[preflightJSONArray addObject:preflightJSON];
				}
			}];

			
			return [[OMPromise all:preflightJSONArray] then:^id(id result) {
				return opsQueue1MutableCopy.copy;
			}];

		}(self.opsQueue1.copy) then:^id(NSArray *opsQueue1Copy) {
			
			NSMutableArray *opsQueue1MutableCopy = opsQueue1Copy.mutableCopy;
			[opsQueue1MutableCopy removeObjectsAtIndexes:[opsQueue1MutableCopy indexesOfObjectsPassingTest:^BOOL(NSArray *savedOp, NSUInteger idx, BOOL *stop) {
				OMPromise *preflightJSON	=	savedOp[0];
				[preflightJSON then:^id(id result) {

					return nil;
				}];
				OMDeferred *d				= savedOp[1];
				
				BOOL sameType = ^BOOL () {
					for (NSArray *_savedOp in [opsQueue1MutableCopy subarrayWithRange:NSMakeRange(0, idx)]) {
						NSString *typeA = [preflightJSON result][@"type"];
						NSString *typeB = [_savedOp[0] result][@"type"];
						if ([typeA isEqualToString:typeB]) {
							*stop = YES;
							return YES;
						}
					}
					return NO;
				}();

				if (!sameType) [d progress:.5];
				return sameType;
			}]];
			
			
			return opsQueue1MutableCopy.copy;
		}] then:^id(NSArray *opsQueue1) {

	//		Send back postflightJSON

			NSArray *postflightJSON = opsQueue1.count == 0 ? @[] : [strongSelf.engine request:^NSMutableArray *(NSMutableArray *preflightJSON) {
				for (NSMutableArray *op in opsQueue1) {
					[preflightJSON addObject:op[0]];
				}
				return preflightJSON;
			}([NSMutableArray array])];

			
			if (!postflightJSON || opsQueue1.count != postflightJSON.count) {
				@throw [NSException exceptionWithName:@"JSON mismatch." reason:[NSString stringWithFormat:@"%@ count does not equal %@", opsQueue1, postflightJSON] userInfo:nil];
				return [OMPromise promiseWithError:[NSError errorWithDomain:NSPOSIXErrorDomain code:777 userInfo:@{NSLocalizedDescriptionKey: @"Request failed."}]];
			}
			else {
				[opsQueue1 enumerateObjectsUsingBlock:^(NSMutableArray *op, NSUInteger idx, BOOL *stop) {
					[postflightJSON[idx] then:^id(id result) {
						[op[1] fulfil:result];
						return nil;
					}];
				}];
			}
			
			return [OMPromise all:postflightJSON];
		}];
		
		
	}(self);
	
//	return d.promise;
}


//- (OMPromise *)lastOp
//{
//	return self.opsQueue.allObjects.count > 0 ? self.opsQueue.allObjects.lastObject : [OMPromise promiseWithResult:nil];
//}



- (void)parserDidChangeSelectedRangesTo:(NSArray *)rangesWithDirections from:(NSArray *)oldRangesWithDirections commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	
		if ([self.delegate respondsToSelector:@selector(parserDidChangeSelectedRangesTo:from:commit:parser:error:)]) {
			[self.delegate parserDidChangeSelectedRangesTo:rangesWithDirections from:oldRangesWithDirections commit:commit parser:self error:error];
		}

}

- (void)parserDidChangeRange:(NSRange)range toString:(NSString *)string fromString:(NSString *)oldString commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	
		if ([self.delegate respondsToSelector:@selector(parserDidChangeRange:toString:fromString:commit:parser:error:)]) {
			[self.delegate parserDidChangeRange:range toString:string fromString:oldString commit:commit parser:self error:error];
		}
	
}

- (void)parserDidParse:(NSRange)range tokens:(NSArray *)tokens commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	
		if ([self.delegate respondsToSelector:@selector(parserDidParse:tokens:commit:parser:error:)]) {
			[self.delegate parserDidParse:range tokens:tokens commit:commit parser:self error:error];
		}
	
}
@end
