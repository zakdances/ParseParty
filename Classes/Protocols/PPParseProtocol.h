//
//  PPParseProtocol.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
#import <NSAttributedRange/NSAttributedRange.h>
#import "PPProtocols.h"
//typedef void (^PPConfirmedResponse) (NSDictionary *responseData);

typedef void (^PPParseEngineResponse) (NSDictionary *attributedStringData, NSArray *tokens, id responseData);

typedef void (^PPReplaceCharactersResponse) (BOOL success, id responseData);

typedef void (^PPModeResponse) (NSString *mode, NSString *fromMode, id responseData);

typedef void (^PPSelectedAttributedRangesResponse) (NSArray *selectedAttributedRanges, id responseData);

typedef void (^PPCursorLocationResponse) (NSUInteger location, id responseData);




typedef void (^PPParseResponse) (NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData);
// Objects who wan't to listen for parser events and recieve data should adopt this protocol.

//@protocol PPParseDelegate <NSObject, PPActionDelegate>
//
//@optional
//
//- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens mode:(NSString *)mode;
//
//@end

// Objects who parse should adopt this protocol.
//@class PPTokenizeOperation;



@protocol PPParseInterface <NSObject>

@required

//- (void)parse:(NSAttributedString *)attributedString response:(PPParseSuccess)response;

//- (void)parse:(NSAttributedString *)attributedString afterReplacingRange:(NSRange)range;

//- (void)setValue:(NSString *)string mode:(NSString *)mode parse:(BOOL)parse response:(PPSetValueResponse)response;
//- (void)mode:(PPModeResponse)response;

- (void)mode:(NSString *)mode response:(PPModeResponse)response;

- (void)cursorLocation:(NSNumber *)cursorLocation response:(PPCursorLocationResponse)response;

- (void)selectedAttributedRanges:(NSArray *)attributedRanges response:(PPSelectedAttributedRangesResponse)response;

- (void)parseRange:(NSRangePlus *)range response:(PPParseResponse)response;

- (void)replaceCharactersAt:(NSRangePlus *)range withCharacters:(NSString *)characters response:(PPReplaceCharactersResponse)response;
//- (void)replaceCharacterAt:(NSUInteger)location withCharacter:(NSString *)character triggerEvent:(NSString *)event parseRange:(NSRange)parseRange response:(PPParseResponse)response;



//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseSubstring:(BOOL)parseSubstring response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;



//@optional

// Convert data such as JSON into Foundation objects such as NSAttributedStrings
//- (void)processParseData:(NSDictionary *)data thenCallBlock:(PPParseResponse)response;

@end

@protocol PPParseEngine <PPRequestProtocol>

@required

- (NSDictionary *)preflightMode:(NSString *)mode;

- (BOOL)postflightMode:(id)responseData response:(PPModeResponse)response;


- (NSDictionary *)preflightCursorLocation:(NSNumber *)location;

- (BOOL)postflightCursorLocation:(id)responseData response:(PPCursorLocationResponse)response;


- (NSDictionary *)preflightSelectedAttributedRanges:(NSArray *)attributedRanges;

- (BOOL)postflightSelectedAttributedRanges:(id)responseData response:(PPSelectedAttributedRangesResponse)response;


- (NSDictionary *)preflightParseRange:(NSRangePlus *)range;

- (BOOL)postflightParseRange:(id)responseData response:(PPParseEngineResponse)response;


- (NSDictionary *)preflightReplaceCharactersAt:(NSRangePlus *)range withCharacters:(NSString *)characters;

- (BOOL)postflightReplaceCharacters:(id)responseData response:(PPReplaceCharactersResponse)response;

@end
//@protocol PPCodeMirrorProtocol <NSObject>
//
//@required
//
//- (void)setValue:(NSString *)string parse:(BOOL)parse response:(PPCodeMirrorResponse)response;
//
//@end
