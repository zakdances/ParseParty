//
//  PPParseProtocol.h
//  Pods
//
//  Created by Zak.
//
//

#define PPRecoveredDataKey @"recoveredData"

#import <Foundation/Foundation.h>
#import "PPBasicProtocols.h"
@class OMDeferred;
@class MGITCommit;
//typedef void (^PPConfirmedResponse) (NSDictionary *responseData);

typedef void (^PPParseResponse) (NSArray *tokens, NSRange range, MGITCommit *commit, NSError *error);

typedef void (^PPModeResponse) (NSString *mode, NSString *fromMode, NSError *error);

typedef void (^PPSelectedRangesResponse) (NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *error);

typedef void (^PPCursorLocationResponse) (NSUInteger location, NSError *error);

typedef void (^PPRangeResponse) (NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *error);

typedef void (^PPDocLengthResponse) (NSUInteger docLength, NSError *error);
//typedef void (^PPParseResponse) (NSArray *tokens, NSRange range, NSDictionary *responseData);
// Objects who wan't to listen for parser events and recieve data should adopt this protocol.

typedef OMPromise * (^PPJSONPromise) (NSDictionary *json);
//
//typedef OMPromise * (^PPPreflightParseProcessing2) (NSArray *range, NSDictionary *commit);
//typedef OMPromise * (^PPPreflightSelectedRangesProcessing2) (NSArray *selectedRanges, NSDictionary *commit);
//typedef OMPromise * (^PPPreflightRangeProcessing2) (NSRange range, NSString *oldString, NSDictionary *commit);

typedef OMPromise * (^PPPreflightParseProcessing3) (NSRange range, MGITCommit *commit);
typedef OMPromise * (^PPPreflightSelectedRangesProcessing3) (NSArray *selectedRanges, MGITCommit *commit);
typedef OMPromise * (^PPPreflightRangeProcessing3) (NSRange range, NSString *string, MGITCommit *commit);
typedef OMPromise * (^PPPreflightModeProcessing3) (NSString *mode);
typedef OMPromise * (^PPPreflightDocLengthProcessing3) ();



//typedef OMPromise * (^PPPreflightRangeBox) (PPPreflightRangeProcessing3);
//typedef OMPromise * (^PPPreflightSelectedRangesBox) (PPPreflightSelectedRangesProcessing3);
//typedef OMPromise * (^PPPreflightParseProcessingBox) (PPPreflightParseProcessing3);
//typedef OMPromise * (^PPPreflightModeBox) (PPPreflightModeProcessing3);
//typedef OMPromise * (^PPPreflightDocLengthBox) (PPPreflightDocLengthProcessing3);


typedef OMPromise * (^PPPostflightProcessing1) (NSDictionary *json);

//typedef OMPromise * (^PPPostflightParseProcessing2) (NSArray *tokens, NSRange range, NSDictionary *commit, NSError *error);
//typedef OMPromise * (^PPPostflightSelectedRangesProcessing2) (NSArray *selectedRanges, NSArray *oldSelectedRanges, NSDictionary *commit, NSError *error);
//typedef OMPromise * (^PPPostflightRangeProcessing2) (NSString *string, NSString *oldString, NSRange range, NSDictionary *commit, NSError *error);

typedef OMPromise * (^PPPostflightParseProcessing3) (NSArray *tokens, NSRange range, MGITCommit *commit, NSError *error);

typedef OMPromise * (^PPPostflightSelectedRangesProcessing3) (NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *error);

typedef OMPromise * (^PPPostflightRangeProcessing3) (NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *error);

typedef OMPromise * (^PPPostflightModeProcessing3) (NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *error);

typedef OMPromise * (^PPPostflightDocLengthProcessing3) (NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *error);


//typedef OMPromise * (^PPPostflightParseProcessingBox) (PPPostflightParseProcessing3);
//@protocol PPParseDelegate <NSObject, PPActionDelegate>
//
//@optional
//
//- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens mode:(NSString *)mode;
//
//@end

// Objects who parse should adopt this protocol.
//@class PPTokenizeOperation;



@protocol PPParseInterface <PPInterface>

@required

//- (void)parse:(NSAttributedString *)attributedString response:(PPParseSuccess)response;

//- (void)parse:(NSAttributedString *)attributedString afterReplacingRange:(NSRange)range;

//- (void)setValue:(NSString *)string mode:(NSString *)mode parse:(BOOL)parse response:(PPSetValueResponse)response;
//- (void)mode:(PPModeResponse)response;

- (void)mode:(NSString *)mode response:(PPModeResponse)response;

- (void)cursorLocation:(NSUInteger)location response:(PPCursorLocationResponse)response;

- (void)selectedRanges:(NSArray *)selectedRanges commit:(MGITCommit *)commit response:(PPSelectedRangesResponse)response;

- (void)parseRange:(NSRange)range commit:(MGITCommit *)commit response:(PPParseResponse)response;

- (void)range:(NSRange)range string:(NSString *)string commit:(MGITCommit *)commit response:(PPRangeResponse)response;

- (void)docLength:(PPDocLengthResponse)response;
//- (void)replaceCharacterAt:(NSUInteger)location withCharacter:(NSString *)character triggerEvent:(NSString *)event parseRange:(NSRange)parseRange response:(PPParseResponse)response;



//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseSubstring:(BOOL)parseSubstring response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;

// TODO: Figure out a better way to handle JSON.
+ (NSDictionary *)rangeToJSON:(NSRange)range;

+ (NSRange)rangeFromJSON:(NSDictionary *)rangeJSON;

+ (NSDictionary *)rangeWithDirectionToJSON:(NSValue *)valueWithRangeWithDirection;

+ (NSValue *)rangeWithDirectionFromJSON:(NSDictionary *)rangeWithDirectionJSON;

+ (NSDictionary *)commitToJSON:(MGITCommit *)commit;

+ (MGITCommit *)commitFromJSON:(NSDictionary *)commitJSON;

+ (NSError *)errorFromJSON:(id)errorJSON;

+ (NSError *)errorFromJSON:(id)errorJSON recoveredData:(NSDictionary *)recoveredData;

//+ (NSDictionary *)removeNulls:(NSDictionary *)dictionary;
//@optional

// Convert data such as JSON into Foundation objects such as NSAttributedStrings
//- (void)processParseData:(NSDictionary *)data thenCallBlock:(PPParseResponse)response;

@end

@protocol PPParseEngine <PPRequestProtocol>

@required

//- (PPOperation *)parseRangeAdapterToJSON:(OMPromise * (^)(PPPreflightParseProcessing3))toJSON fromJSON:(void(^)(OMPromise *json, PPPostflightParseProcessing3 callback))fromJSON;

//- (PPOperation *)parseRangeAdapterToJSON:(void(^)(PPPreflightParseProcessing3))toJSON fromJSON:(PPRangeResponse(^)(OMDeferred *))fromJSON;

- (void)parseRangeAdapterToJSON:(void(^)(PPPreflightParseProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPParseResponse) ) )fromJSON;

//- (PPOperation *)selectedRangesAdapterToJSON:(void(^)(PPPreflightSelectedRangesProcessing3))toJSON fromJSON:(PPSelectedRangesResponse(^)(OMDeferred *))fromJSON;

- (void)selectedRangesAdapterToJSON:(void(^)(PPPreflightSelectedRangesProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPSelectedRangesResponse) ) )fromJSON;
//- (PPOperation *)rangeAdapterToJSON:(OMPromise * (^)(PPPreflightRangeProcessing3))toJSON fromJSON:(void(^)(OMPromise *json, PPPostflightRangeProcessing3 callback))fromJSON;

- (void)rangeAdapterToJSON:(void(^)(PPPreflightRangeProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPRangeResponse) ) )fromJSON;

//- (PPOperation *)modeAdapterToJSON:(OMPromise * (^)(PPPreflightModeProcessing3))toJSON fromJSON:(void(^)(OMPromise *json, PPPostflightModeProcessing3 callback))fromJSON;

//- (PPOperation *)modeAdapterToJSON:(void(^)(PPPreflightModeProcessing3))toJSON fromJSON:(PPModeResponse(^)(OMDeferred *))fromJSON;

- (void)modeAdapterToJSON:(void(^)(PPPreflightModeProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPModeResponse) ) )fromJSON;
// - (PPOperation *)docLengthAdapterToJSON:(OMPromise * (^)(PPPreflightDocLengthProcessing3))toJSON fromJSON:(void(^)(OMPromise *json, PPPostflightDocLengthProcessing3 callback))fromJSON;

//- (PPOperation *)docLengthAdapterToJSON:(void(^)(PPPreflightDocLengthProcessing3))toJSON fromJSON:(PPDocLengthResponse(^)(OMDeferred *))fromJSON;

- (void)docLengthAdapterToJSON:(void(^)(PPPreflightDocLengthProcessing3))toJSON fromJSON:( void(^)( OMPromise *(^)(OMPromise *, PPDocLengthResponse) ) )fromJSON;
//- (NSDictionary *)preflightCursorLocation:(NSUInteger)location;
//
//- (BOOL)postflightCursorLocation:(id)responseData response:(PPCursorLocationResponse)response;
//
//
//- (NSDictionary *)preflightMode:(NSString *)mode;
//
//- (BOOL)postflightMode:(id)responseData response:(PPModeResponse)response;
//
//
//- (NSDictionary *)preflightDocLength;
//
//- (BOOL)postflightDocLength:(id)responseData response:(PPDocLengthResponse)response;

@end



@protocol PPPostflightEngine <NSObject>

//@required
//
//- (BOOL)postflightRange:(id)responseData response:(PPPostflightRangeResponse)response;
//
//- (BOOL)postflightSelectedRanges:(id)responseData response:(PPPostflightSelectedRangesResponse)response;
//
//- (BOOL)postflightParseRange:(id)responseData response:(PPPostflightParseResponse)response;

@end



@protocol PPDelegate <PPStatusDelegate>

@optional

- (void)parserDidChangeSelectedRangesTo:(NSArray *)rangesWithDirections from:(NSArray *)oldRangesWithDirections commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error;

- (void)parserDidChangeRange:(NSRange)range toString:(NSString *)string fromString:(NSString *)oldString commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error;

- (void)parserDidParse:(NSRange)range tokens:(NSArray *)tokens commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error;

@end
//@protocol PPCodeMirrorProtocol <NSObject>
//
//@required
//
//- (void)setValue:(NSString *)string parse:(BOOL)parse response:(PPCodeMirrorResponse)response;
//
//@end
