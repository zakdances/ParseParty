//
//  PPCodeMirror+Parse.m
//  Pods
//
//  Created by Zak.
//
//

#define PPRequestTypeMode @"mode"
#define PPRequestTypeParse @"parse"
#define PPRequestTypeCursor @"cursor"
#define PPRequestTypeSelectedRanges @"selectedRanges"
#define PPRequestTypeRange @"range"
#define PPRequestTypeDocLength @"docLength"
//#define PPRequestTypeGetRange @"getRange"

#define PPTypeKey @"type"
#define PPTokensKey @"tokens"
#define PPRangesKey @"ranges"
#define PPOldRangesKey @"oldRanges"
#define PPRangeKey @"range"
#define PPStringKey @"string"
#define PPOldStringKey @"oldString"
#define PPModeKey @"mode"
#define PPOldModeKey @"fromMode"
#define PPDocLengthKey @"length"
#define PPCommitKey @"commit"
#define PPErrorKey @"error"

#import "PPCodeMirror+Parse.h"
#import "PPOperation.h"
#import "NSValue+RangeWithDirection.h"
#import "jNSValueWithRange.h"

#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <Jantle/Jantle.h>
#import <objc/objc-runtime.h>
#import <MGit-Objective-C/MGit.h>
#import <OMPromises/OMPromises.h>

@interface NSDictionary (stufff)

- (instancetype)copyWithoutNullKeysOrValues;

@end

@implementation NSDictionary (stufff)

- (instancetype)copyWithoutNullKeysOrValues
{
	return ^NSDictionary * (NSMutableDictionary *md) {
		for (id key in self) {
			id val = md[key];
			if (key == NSNull.null || val == NSNull.null) [md removeObjectForKey:key];
		}
		return md.copy;
	}(self.mutableCopy);
}

@end

@implementation PPCodeMirror (Parse)

//PPPostflightParseProcessing3
- (void)parseRangeAdapterToJSON:(void(^)(PPPreflightParseProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPParseResponse) ) )fromJSON
{
	^(PPCodeMirror *strongSelf) {
		!toJSON ? nil : toJSON( ^OMPromise *(NSRange range, MGITCommit *commit) {
			
			return [OMPromise promiseWithResult:^NSDictionary *(NSDictionary *nd) {
				
				return [@{PPRangeKey: [strongSelf.interfaceDelegate.class rangeToJSON:range],
						  PPCommitKey: commit ? [strongSelf.interfaceDelegate.class commitToJSON:commit] : NSNull.null,
						  PPTypeKey: PPRequestTypeParse} copyWithoutNullKeysOrValues];
				
			}([NSDictionary dictionary])];
			
		});
		
		
		!fromJSON ? nil : fromJSON( ^OMPromise *(OMPromise *json, PPParseResponse cb) {
			return [json then:^id(NSDictionary *json) {
				
			
				NSRange r = [strongSelf.interfaceDelegate.class rangeFromJSON:json[PPRangeKey]];
				MGITCommit *c = [strongSelf.interfaceDelegate.class commitFromJSON:json[PPCommitKey]];
				
				NSArray *tokens = ^NSArray *(NSMutableArray *na) {
					for (NSValue *rwd in json[PPTokensKey]) {
						[na addObject:[strongSelf.interfaceDelegate.class rangeWithDirectionToJSON:rwd]];
					}
					return na.copy;
				}([NSMutableArray array]);
				
				NSString *type = json[PPTypeKey];
				
				NSDictionary *pd = @{PPRangeKey: [NSValue valueWithRange:r],
									  PPTokensKey: tokens,
									  PPCommitKey: c,
									  PPTypeKey: type};
//									 PPErrorKey: e ? : NSNull.null} copyByRemovingNulls];
				
				NSError *e = json[PPErrorKey] ? [strongSelf.interfaceDelegate errorFromJSON:json[PPErrorKey] recoveredData:pd] : nil;
				
				cb(tokens,r,c,e);
				
				return e ? [OMPromise promiseWithError:e] : [OMPromise promiseWithResult:pd];
			}];
		});
	}(self);
}
//PPPreflightSelectedRangesProcessing3
- (void)selectedRangesAdapterToJSON:(void(^)(PPPreflightSelectedRangesProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPSelectedRangesResponse) ) )fromJSON
{
	^(PPCodeMirror *strongSelf) {
		!toJSON ? nil : toJSON( ^OMPromise *(NSArray *selectedRanges, MGITCommit *commit) {
			
			return [OMPromise promiseWithResult:^NSDictionary *(NSDictionary *nd) {
				
				return [@{PPRangesKey: ^NSArray *(NSMutableArray *na) {
							for (NSValue *rwd in selectedRanges) {
								[na addObject:[strongSelf.interfaceDelegate.class rangeWithDirectionToJSON:rwd]];
							}
							return na.copy;
							}([NSMutableArray array]),
						  PPCommitKey: commit ? [strongSelf.interfaceDelegate.class commitToJSON:commit] : NSNull.null,
						 PPTypeKey: PPRequestTypeSelectedRanges} copyWithoutNullKeysOrValues];
				
			}([NSDictionary dictionary])];
			
		});
		
		
		!fromJSON ? nil : fromJSON( ^OMPromise *(OMPromise *json, PPSelectedRangesResponse cb) {
			return [json then:^id(NSDictionary *json) {

				NSArray *rswds = ^NSArray * (NSMutableArray *na) {
					for (NSDictionary *rwdJSON in json[PPRangesKey]) {
						[na addObject:[strongSelf.interfaceDelegate.class rangeWithDirectionFromJSON:json[PPRangesKey]]];
					}
					return na.copy;
				}([NSMutableArray array]);
				
				NSArray *orswds = ^NSArray * (NSMutableArray *na) {
					for (NSDictionary *orwdJSON in json[PPOldRangesKey]) {
						[na addObject:[strongSelf.interfaceDelegate.class rangeWithDirectionFromJSON:json[PPOldRangesKey]]];
					}
					return na.copy;
				}([NSMutableArray array]);
				
				NSString *type = json[PPTypeKey];
				MGITCommit *c = [strongSelf.interfaceDelegate.class commitFromJSON:json[PPCommitKey]];
				
				NSDictionary *pd = @{PPRangesKey: rswds,
									 PPOldRangesKey: orswds,
									 PPCommitKey: c,
									 PPTypeKey: type};
				
				NSError *e = json[PPErrorKey] ? [strongSelf.interfaceDelegate errorFromJSON:json[PPErrorKey] recoveredData:pd] : nil;
				
				cb(rswds,orswds,c,e);
				
				return e ? [OMPromise promiseWithError:e] : [OMPromise promiseWithResult:pd];
			}];
			
		});
	}(self);
//	return [PPOperation attachToJSON:toJSON ? ^OMPromise *(OMDeferred *d) {
//		toJSON( ^OMPromise *(NSArray *selectedRanges, MGITCommit *commit) {
////			______________________________
//			NSMutableDictionary *requestData = @{@"type":PPRequestTypeSelectedRanges}.mutableCopy;
//			if (selectedRanges) {
//				
//				NSMutableArray *rangesData = [NSMutableArray array];
//				
//				//		Serialize range data into JSON.
//				for (NSValue *selectedRange in selectedRanges) {
//					NSError *error;
//					NSDictionary *rangeJSON = [selectedRange toJSON:[jNSValueWithRangeAndDirection modelWithValue:selectedRange options:jOptionPrettyPrinted error:&error]];
//					if (error) NSLog(@"%@", error.localizedDescription);
//					
//					[rangesData addObject:rangeJSON];
//				}
//				
//				requestData[@"ranges"] = rangesData;
//				requestData[@"commit"] = @{@"id": commit.id.UUIDString};
//			}
//
//			[d fulfil:requestData];
//			return d.promise;
//		});
//		
//		return d.promise;
//		
//	}([OMDeferred deferred]) : nil andFromJSON:fromJSON ? ^OMPromise *(OMDeferred *json) {
//		
////		NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeSelectedRanges fromResponseData:json];
//		PPSelectedRangesResponse callback = fromJSON(json);
//
//		return [json.promise then:^id(NSDictionary *json) {
//			
////			NSMutableDictionary *pd = [NSMutableDictionary dictionary];
//			NSDictionary *pd = ^NSDictionary *(NSArray *rwds, NSArray *orwds, NSDictionary *c, NSString *e) {
//				
//				return [self.interfaceDelegate.class removeNulls:
//						@{PPRangesKey: ^NSArray *(NSMutableArray *na) {
//							for (NSDictionary *rwd in rwds) {
//								[na addObject:[self.interfaceDelegate.class rangeWithDirectionFromJSON:rwd]];
//							}
//							return na.copy;
//							}([NSMutableArray array]),
//						 PPOldRangesKey: ^NSArray *(NSMutableArray *na) {
//							 for (NSDictionary *orwd in orwds) {
//								 [na addObject:[self.interfaceDelegate.class rangeWithDirectionFromJSON:orwd]];
//							 }
//							 return na.copy;
//						 }([NSMutableArray array]),
//						 PPCommitKey: [self.interfaceDelegate.class commitFromJSON:c],
//						 PPErrorKey: e ? [self.interfaceDelegate.class errorFromJSON:e] : NSNull.null}];
//
//			}(json[PPRangesKey], json[PPOldRangesKey], json[PPCommitKey], json[PPErrorKey]);
//			
//			
//			if (pd[PPErrorKey]) {
//				callback(nil, nil, pd[PPCommitKey], pd[PPErrorKey]);
//				return [OMPromise promiseWithError:pd[PPErrorKey]];
//			}
//			else
//				return pd;
//		}];
//
//	}([OMDeferred deferred]) : nil];
}

- (void)rangeAdapterToJSON:(void(^)(PPPreflightRangeProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPRangeResponse) ) )fromJSON
{
	^(PPCodeMirror *strongSelf) {
		!toJSON ? nil : toJSON( ^OMPromise *(NSRange range, NSString *string, MGITCommit *commit) {
			
			return [OMPromise promiseWithResult:^NSDictionary *(NSDictionary *nd) {
				
				return [@{PPRangeKey: [strongSelf.interfaceDelegate.class rangeToJSON:range],
						 PPStringKey: string,
						  PPCommitKey: commit ? [strongSelf.interfaceDelegate.class commitToJSON:commit] : NSNull.null,
						 PPTypeKey: PPRequestTypeRange} copyWithoutNullKeysOrValues];
				
			}([NSDictionary dictionary])];

		});


		!fromJSON ? nil : fromJSON( ^OMPromise *(OMPromise *json, PPRangeResponse cb) {
			return [json then:^id(NSDictionary *json) {
				NSRange r = [strongSelf.interfaceDelegate.class rangeFromJSON:json[PPRangeKey]];
				NSString *s = json[PPStringKey];
				NSString *os = json[PPOldStringKey];
				MGITCommit *c = [strongSelf.interfaceDelegate.class commitFromJSON:json[PPCommitKey]];
				NSString *type = json[PPTypeKey];
				
				NSDictionary *pd = [@{PPRangeKey: [NSValue valueWithRange:r],
									 PPStringKey: s,
									 PPOldStringKey: os ? : NSNull.null,
									 PPCommitKey: c,
									 PPTypeKey: type} copyWithoutNullKeysOrValues];
				
				NSError *e = json[PPErrorKey] ? [strongSelf.interfaceDelegate errorFromJSON:json[PPErrorKey] recoveredData:pd] : nil;
				
				cb(s,os,r,c,e);
				
				return e ? [OMPromise promiseWithError:e] : [OMPromise promiseWithResult:pd];
			}];
				
		});
	}(self);
}

- (void)modeAdapterToJSON:(void(^)(PPPreflightModeProcessing3))toJSON fromJSON:( void(^)( OMPromise * (^)(OMPromise *, PPModeResponse) ) )fromJSON
{
	^(PPCodeMirror *strongSelf) {
		!toJSON ? nil : toJSON( ^OMPromise * (NSString *mode) {
			
			return [OMPromise promiseWithResult:^NSDictionary * () {
				
				return [@{PPTypeKey: PPRequestTypeMode,
						 PPModeKey: mode} copyWithoutNullKeysOrValues];
				
			}()];
			
		});
		
		
		!fromJSON ? nil : fromJSON( ^OMPromise * (OMPromise *json, PPModeResponse cb) {
			return [json then:^id(NSDictionary *json) {
				NSString *m = json[PPModeKey];
				NSString *om = json[PPOldModeKey];
				NSString *type = json[PPTypeKey];
				
				
				
				NSDictionary *pd = [@{PPModeKey: m,
									 PPOldModeKey: om ? : NSNull.null,
									 PPTypeKey: type} copyWithoutNullKeysOrValues];
					
				NSError *e = json[PPErrorKey] ? [strongSelf.interfaceDelegate errorFromJSON:json[PPErrorKey] recoveredData:pd] : nil;
					
				cb(m,om,e);
				
				return e ? [OMPromise promiseWithError:e] : [OMPromise promiseWithResult:pd];
			}];
		});
	}(self);
}

- (void)docLengthAdapterToJSON:(void(^)(PPPreflightDocLengthProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPDocLengthResponse) ) )fromJSON
{
	^(PPCodeMirror *strongSelf) {
		!toJSON ? nil : toJSON( ^OMPromise *(NSUInteger length) {
			
			return [OMPromise promiseWithResult:^NSDictionary * (NSDictionary *json) {
				
				return [@{PPTypeKey: PPRequestTypeDocLength,
						 PPDocLengthKey: @(length)} copyWithoutNullKeysOrValues];
				
			}([NSDictionary dictionary])];
			
		});
		
		
		!fromJSON ? nil : fromJSON( ^OMPromise *(OMPromise *json, PPDocLengthResponse cb) {
			return [json then:^id(NSDictionary *json) {
				NSNumber *l = json[PPDocLengthKey];
				NSString *type = json[PPTypeKey];
				
				NSDictionary *pd = @{PPDocLengthKey: l,
									 PPTypeKey: type};
				
				NSError *e = json[PPErrorKey] ? [strongSelf.interfaceDelegate errorFromJSON:json[PPErrorKey] recoveredData:pd] : nil;
				
				cb(l.unsignedIntegerValue,e);
				
				return e ? [OMPromise promiseWithError:e] : [OMPromise promiseWithResult:pd];
			}];
		});
	}(self);
}




//- (NSDictionary *)preflightMode:(NSString *)mode
//{
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeMode}.mutableCopy;
//	if (mode) requestData[@"mode"] = mode;
//	return requestData;
//}
//
//- (BOOL)postflightMode:(id)responseData response:(PPModeResponse)response
//{
//	NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeMode fromResponseData:responseData];
//	
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(nil, nil, error);
//		return YES;
//	}
//	
//	NSString		*mode		= data[@"mode"];
//	NSString		*fromMode	= data[@"fromMode"];
//	response(mode,fromMode,nil);
//	return YES;
//}
//
//
//- (NSDictionary *)preflightCursorLocation:(NSNumber *)location
//{
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeCursor}.mutableCopy;
//	if (location) requestData[@"location"] = location;
//	return requestData;
//}
//
//- (BOOL)postflightCursorLocation:(id)responseData response:(PPCursorLocationResponse)response
//{
//	NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeCursor fromResponseData:responseData];
//	
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(NSNotFound,error);
//		return YES;
//	}
//	
//	NSNumber		*location		= data[@"location"];
//	response(location.unsignedIntegerValue,nil);
//	return YES;
//}
//
//
//- (NSDictionary *)preflightSelectedRanges:(NSArray *)selectedRanges change:(MGITCommit *)change
//{
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeSelectedRanges}.mutableCopy;
//	
//	if (selectedRanges) {
//		
//		NSMutableArray *rangesData = [NSMutableArray array];
//		
////		Serialize range data into JSON.
//		for (NSValue *selectedRange in selectedRanges) {
//			NSError *error;
//			NSDictionary *rangeJSON = [selectedRange toJSON:[jNSValueWithRangeAndDirection modelWithValue:selectedRange options:jOptionPrettyPrinted error:&error]];
//			if (error) NSLog(@"%@", error.localizedDescription);
//			
//			[rangesData addObject:rangeJSON];
//		}
//		
//		requestData[@"ranges"] = rangesData;
//		requestData[@"commit"] = @{@"id": change.id.UUIDString};
//	}
//	
//	return requestData;
//}
//
//- (BOOL)postflightSelectedRanges:(id)responseData response:(PPPostflightSelectedRangesResponse)response
//{
//	NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeSelectedRanges fromResponseData:responseData];
//
//	NSDictionary *commit = data[@"commit"];
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(nil,nil,commit,error);
//		return YES;
//	}
//	
//	NSArray	*selectedRanges	= data[@"ranges"];
//	NSArray	*oldSelectedRanges	= data[@"oldRanges"];
//	
//	response(selectedRanges,oldSelectedRanges,commit,nil);
//	return YES;
//}
//
//
//- (NSDictionary *)preflightParseRange:(NSRange)range change:(MGITCommit *)change
//{
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeParse}.mutableCopy;
//	
//	if (range.location != NSNotFound && range.length != NSNotFound) {
//		NSValue *valueWithRange = [NSValue valueWithRange:range];
//		
//		NSError *error;
//		requestData[@"range"] = [valueWithRange toJSON:[jNSValue modelWithValue:valueWithRange error:&error]];
//		if (error) NSLog(@"%@", error.localizedDescription);
//		
//		requestData[@"commit"] = @{@"id": change.id.UUIDString};
//	}
//	return requestData;
//}
//
//- (BOOL)postflightParseRange:(id)responseData response:(PPPostflightParseResponse)response
//{
//	NSDictionary	*data					= [self.class requestDataNamed:PPRequestTypeParse fromResponseData:responseData];
//	
//	NSDictionary *commit = data[@"commit"];
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(nil,NSMakeRange(NSNotFound, NSNotFound),commit,error);
//		return YES;
//	}
//
//	NSDictionary	*rangeData	= data[@"range"];
//	NSArray			*tokens		= data[@"tokens"];
//
//	NSError *JSONerror;
//	NSRange range = [[NSValue fromJSON:rangeData modelOfClass:jNSValue.class error:&JSONerror] rangeValue];
//	if (JSONerror) NSLog(@"%@", JSONerror.localizedDescription);
//	
//
//	response(tokens,range,commit,nil);
//	return YES;
//}
//
//
////- (NSDictionary *)preflightReplaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters
////{
////	NSMutableDictionary *requestData = @{@"type":PPRequestTypeReplaceCharacters}.mutableCopy;
////	if (range.location != NSNotFound && range.length != NSNotFound && characters) {
////		NSError *error;
////		requestData[@"range"]		= [[NSValue valueWithRange:range] toJSONFromValueWithRange:&error];
////		if (error) NSLog(@"%@", error.localizedDescription);
////		
////		requestData[@"characters"]	= characters;
////	}
////	return requestData;
////}
////
////- (BOOL)postflightReplaceCharacters:(id)responseData response:(PPReplaceCharactersResponse)response
////{
////	NSDictionary	*data					= [self.class requestDataNamed:PPRequestTypeReplaceCharacters fromResponseData:responseData];
////	BOOL	success	= [data[@"success"] boolValue];
////	response(success);
////	return YES;
////}
//
//
////- (NSDictionary *)preflightGetRange:(NSRange)range
////{
////	NSMutableDictionary *requestData = @{@"type":PPRequestTypeGetRange}.mutableCopy;
////	if (range.location != NSNotFound && range.length != NSNotFound) {
////		NSError *error;
////		requestData[@"range"]		= [[NSValue valueWithRange:range] toJSONFromValueWithRange:&error];
////		if (error) NSLog(@"%@", error.localizedDescription);
////	}
////	return requestData;
////}
////
////- (BOOL)postflightGetRange:(id)responseData response:(PPRequestTypeRange)response
////{
////	NSDictionary	*data	= [self.class requestDataNamed:PPRequestTypeGetRange fromResponseData:responseData];
////	NSString	*string	= data[@"string"];
////	response(string);
////	return YES;
////}
//
//- (NSDictionary *)preflightRange:(NSRange)range string:(NSString *)string change:(MGITCommit *)change
//{
//	if (range.location == NSNotFound || range.length == NSNotFound) {
//		@throw [NSException exceptionWithName:@"Value error." reason:@"Invalid range send to ParseParty." userInfo:nil];
//	}
//
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeRange}.mutableCopy;
//	
//	NSValue *valueWithRange = [NSValue valueWithRange:range];
//	
//	NSError *error;
//	requestData[@"range"] = [valueWithRange toJSON:[jNSValue modelWithValue:valueWithRange error:&error]];
//	if (error) NSLog(@"%@", error.localizedDescription);
//
//	if (string) {
//		requestData[@"string"] = string;
//		requestData[@"commit"] = @{@"id": change.id.UUIDString};
//	}
//	
//	return requestData;
//}
//
//- (BOOL)postflightRange:(id)responseData response:(PPPostflightRangeResponse)response
//{
//	NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeRange fromResponseData:responseData];
//	
//	NSDictionary *commit = data[@"commit"];
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(nil, nil, NSMakeRange(NSNotFound, NSNotFound), commit, error);
//		return YES;
//	}
//	
//	NSString		*string		= data[@"string"];
//	NSString		*oldString	= data[@"oldString"];
//
//	NSError *JSONError;
//	NSRange range = [[NSValue fromJSON:data[@"range"] modelOfClass:jNSValue.class error:&JSONError] rangeValue];
//	if (JSONError) NSLog(@"%@", JSONError.localizedDescription);
//
//	response(string, oldString, range, commit, nil);
//	return YES;
//}
//
//
//- (NSDictionary *)preflightDocLength
//{
//	NSMutableDictionary *requestData = @{@"type":PPRequestTypeDocLength}.mutableCopy;
//	return requestData;
//}
//
//- (BOOL)postflightDocLength:(id)responseData response:(PPDocLengthResponse)response
//{
//	NSDictionary	*data		= [self.class requestDataNamed:PPRequestTypeDocLength fromResponseData:responseData];
//	
//	NSString *errorString = data[@"error"];
//	NSError *error = errorString ? [NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}] : nil;
//	if (error) {
//		response(NSNotFound, nil);
//		return YES;
//	}
//	
//	NSUInteger		docLength	= [data[@"length"] unsignedIntegerValue];
//	response(docLength, nil);
//	return YES;
//}






@end
