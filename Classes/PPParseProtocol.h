//
//  PPParseProtocol.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

typedef void (^PPConfirmedResponse) (NSDictionary *responseData);

typedef void (^PPParseResponse) (NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData);

typedef void (^PPReplaceResponse) (NSDictionary *responseData);

typedef void (^PPModeResponse) (NSString *mode, NSDictionary *responseData);
// Objects who wan't to listen for parser events and recieve data should adopt this protocol.

//@protocol PPParseDelegate <NSObject, PPActionDelegate>
//
//@optional
//
//- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens mode:(NSString *)mode;
//
//@end

// Objects who parse should adopt this protocol.

@protocol PPParseProtocol <NSObject>

@required

//- (void)parse:(NSAttributedString *)attributedString response:(PPParseSuccess)response;

//- (void)parse:(NSAttributedString *)attributedString afterReplacingRange:(NSRange)range;

//- (void)setValue:(NSString *)string mode:(NSString *)mode parse:(BOOL)parse response:(PPSetValueResponse)response;
- (void)getMode:(PPModeResponse)response;

- (void)setMode:(NSString *)mode response:(PPModeResponse)response;

- (void)parseRange:(NSRange)range response:(PPParseResponse)response;

//- (void)replaceCharacterAt:(NSUInteger)location withCharacter:(NSString *)character triggerEvent:(NSString *)event parseRange:(NSRange)parseRange response:(PPParseResponse)response;

- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPReplaceResponse)response;

- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseSubstring:(BOOL)parseSubstring response:(PPParseResponse)response;

//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode thenParseRange:(NSRange)parseRange response:(PPParseResponse)response;

@optional

//@property (weak) id <PPParseDelegate> parseDelegate;

// Convert data such as JSON into Foundation objects such as NSAttributedStrings
- (void)processParseData:(NSDictionary *)data thenCallBlock:(PPParseResponse)response;

@end

//@protocol PPCodeMirrorProtocol <NSObject>
//
//@required
//
//- (void)setValue:(NSString *)string parse:(BOOL)parse response:(PPCodeMirrorResponse)response;
//
//@end
