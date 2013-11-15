//
//  PPOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "ParseParty.h"

@implementation PPOperation

- (id)init
{
    self = [super init];
    if (self) {
//		self.dependants_weak = [NSHashTable weakObjectsHashTable];
//		self.dependants = [NSHashTable weakObjectsHashTable];
////		[self dependantReferenceStrength:PPOperationDependantReferenceWeak];
////		self.dependantReferenceStrength = PPOperationDependantReferenceWeak;
//		_executionBlocks = [NSMutableArray array];
//		
//        self.data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)preflight:(id<PPRequestProtocol>)parseEngine
{
	// Override me
//	_preflightData = [parseEngine ]
}

- (void)postflight:(id<PPRequestProtocol>)parseEngine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
	// Override me
}

- (void)callCallback
{
	
}

+ (instancetype)operation
{
	return [self new];
}

@end
