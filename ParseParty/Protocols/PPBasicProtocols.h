//
//  PPProtocols.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
@class ParseParty;
@class PPOperation;
@class OMPromise;
//@protocol PPLoadDelegate <NSObject>
//
//@optional
//
//- (void)parserLoaded:(ParseParty *)parser;
//
//@end

typedef NS_ENUM(NSUInteger, PPStatus) {
    PPStatusUnloaded,
    PPStatusReady,
	PPStatusBusy
};

typedef void (^PPCompoundResponse) (NSArray *compoundResponseData);

//typedef void (^PPEngineResponse) (id responseData);

//typedef void (^PPEngineResponseError) (NSString *error);
//typedef void (^PPTokenizeResponse) (NSArray *tokens);





@protocol PPStatusDelegate <NSObject>

@optional

- (void)parserStatusDidChangeTo:(PPStatus)newStatus from:(PPStatus)oldStatus parser:(ParseParty *)parser;

- (void)parserDocDidChange:(NSDictionary *)responseData parser:(ParseParty *)parser;

@end



@protocol PPInterface <PPStatusDelegate>

@required

- (void)addOp:(id(^)(id))op;

//- (void)addRequest:(PPOperation *)request;

@end



// TODO: Split this into two protocols.
@protocol PPRequestProtocol <NSObject>

@optional

//- (void)beginRequest;

//- (void)endRequest:(PPCompoundResponse)compoundResponse;

//- (void)request:(NSDictionary *)requestData;

- (NSArray *)request:(NSArray *)requestData;

@end

//@protocol PPTokenizeInterface <NSObject>
//
//@required
//
//- (void)tokenize:(NSString *)string mode:(NSString *)mode response:(PPTokenizeResponse)response;
//
//@end
//
//@protocol PPTokenizeEngine <PPRequestProtocol>
//
//@required
//
//- (NSDictionary *)preflightTokenize:(NSString *)stringToTokenize;
//
//- (BOOL)postflightTokenize:(id)responseData response:(PPTokenizeResponse)response;
//
//@end



