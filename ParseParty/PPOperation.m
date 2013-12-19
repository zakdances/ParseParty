//
//  PPOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "PPParseProtocol.h"
#import <OMPromises/OMPromises.h>

@interface PPOperation ()

@property (strong) NSMutableArray *subOps;

@end

@implementation PPOperation

- (id)init
{
    self = [super init];
    if (self) {
		
		
		self.v = [NSMutableDictionary dictionary];
//		OMDeferred *pfdd	= [OMDeferred deferred];
//		OMPromise *pfd		= pfdd.promise;
//		
//		OMDeferred *icd	= [OMDeferred deferred];
//		OMPromise *ic		= pfdd.promise;
//		
//		OMDeferred *dd = self.doneDeferred;
		
//		self.doneDeferred = [OMDeferred deferred];
//		self.done = self.doneDeferred.promise;
//		
//		self.postflightDataDeferred = [OMDeferred deferred];
//		self.postflightData = self.postflightDataDeferred.promise;
//		
//		self.interfaceCallbackDeferred = [OMDeferred deferred];
//		self.interfaceCallback = self.interfaceCallbackDeferred.promise;
		
		
//		OMDeferred *icd	= self.interfaceCallbackDeferred;
//		OMDeferred *dd = self.doneDeferred;
//		
//		[self.postflightData failed:^(NSError *error) {
//			[icd fail:error];
//		}];
//		
//		[self.interfaceCallback failed:^(NSError *error) {
//			[dd fail:error];
//		}];
    }
    return self;
}

+ (instancetype)attachToJSON:(OMPromise *)toJSON andFromJSON:(OMPromise *)fromJSON
{
	PPOperation *op = [self operation];
	op.toJSON = toJSON;
	op.fromJSON = fromJSON;
	return op;
}
//- (void)callPreflight
//{
//	if (self.preflight) {
//		self.preflight();
//	};
//}

//- (void)callPostflight
//{
//
//
//	PPOperationPromise fin = ^(NSDictionary *processedData) {
//		_status = @"done";
//
//		for (PPOperationPromise promise in _promises) {
//			promise(processedData);
//		}
//	};
//	
//	
//
//	self.postflight(fin);
//}

//- (void)callInterfaceCallbackCallback
//{
//	if (self.interfaceCallback) {
//		self.interfaceCallback();
//	}
//}

//- (void)addPromise:(PPOperationPromise)promise
//{
//	PPOperationPromise _promise = ^(NSDictionary *processedData) {
//		
//		promise(processedData);
//		[_promises removeObject:promise];
//
//	};
//
//	[_promises addObject:_promise];
//	
//	
//	if ([_status isEqualToString:@"done"]) {
//		_promise(self.postflightData);
//	}
//}

//- (OMPromise *)promise
//{
//	return _doneD.promise;
//}



//- (void)subOpDone
//{
//	_subOpsCompleted = _subOpsCompleted + 1;
//}

+ (instancetype)operation
{
	return [self new];
}

@end
