//
//  PPOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
//#import "PPBasicProtocols.h"
@class OMPromise;
//@class OMDeferred;
//@class MGITCommit;

//typedef void (^PPOperationProcessedDataResponse) (NSDictionary *processedData);
//
//typedef NSDictionary * (^PPOperationPreflight) ();
//
//typedef OMPromise * (^PPJSONAdapter) ();

//typedef OMPromise * (^PPOperationPostflight) (NSDictionary *postflightData);
//typedef void (^PPOperationInterfaceCallback) ();



//typedef void (^PPBlock) (PPOperation *op);
//
//typedef NS_ENUM(NSUInteger, PPOperationDependantReferenceStrength) {
//    PPOperationDependantReferenceStrong,
//    PPOperationDependantReferenceWeak
//};

@interface PPOperation : NSObject {
//	__strong NSMutableArray *_promises;
//	__strong NSString *_status;
//	NSUInteger _subOpsCompleted;
	
//	__strong OMDeferred *_doneD;
}

@property BOOL running;
@property (strong) NSString *_scratchPad;
//@property (strong) id preflightData;
//@property (strong) OMDeferred *preflightDataDeferred;

//@property (strong) OMDeferred *postflightDataDeferred;
//@property (strong) OMPromise *postflightData;

//@property (strong) PPOperationPreflight preflight;
//@property (strong) PPOperationPostflight postflight;

//@property (strong) OMDeferred *interfaceCallbackDeferred;
//@property (strong) OMPromise *interfaceCallback;
//@property (strong) PPOperationProcessedDataResponse error;

//@property (strong,readonly) NSMutableArray *subOps;
//@property (strong) OMDeferred *doneDeferred;

@property (strong) OMPromise *toJSON;
@property (strong) OMPromise *fromJSON;

@property (strong) NSArray *keys;
@property (strong) NSMutableDictionary *v;
//@property (strong) OMPromise *done;

//@property (strong) MGITCommit *commit;
//- (void)callPreflight;
//typedef void (^PPOperationPromise) (NSDictionary *processedData);

//- (void)callPostflight;

//- (void)done:(OMPromise *)promise;
//- (void)callInterfaceCallbackCallback;

//- (void)postflight:(id<PPRequestProtocol>)parseEngine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished;
// Used for debugging purposes

+ (instancetype)attachToJSON:(OMPromise *)toJSON andFromJSON:(OMPromise *)fromJSON;

+ (instancetype)operation;

@end


