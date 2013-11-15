//
//  PPOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
//#import "PPProtocols.h"
@class PPRequestProtocol;

typedef void (^PPOperationProcessedResponse) (NSDictionary *processedData);
//typedef void (^PPBlock) (PPOperation *op);
//
//typedef NS_ENUM(NSUInteger, PPOperationDependantReferenceStrength) {
//    PPOperationDependantReferenceStrong,
//    PPOperationDependantReferenceWeak
//};

@interface PPOperation : NSObject {
//	__strong id _preflightData;
}

@property (strong) id preflightData;
//@property (strong) void (^responseCallback)();

- (void)preflight:(id<PPRequestProtocol>)parseEngine;

- (void)postflight:(id<PPRequestProtocol>)parseEngine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished;

- (void)callCallback;

+ (instancetype)operation;

@end

