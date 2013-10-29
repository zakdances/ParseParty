//
//  PPParseProtocol.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

typedef void (^PPParseResponse) (NSDictionary *responseData);

typedef void (^PPSetValueResponse) (NSDictionary *responseData);

@protocol PPParseProtocol <NSObject>

@required

//- (void)parse:(NSAttributedString *)attributedString response:(PPParseSuccess)response;

//- (void)parse:(NSAttributedString *)attributedString afterReplacingRange:(NSRange)range;

//- (void)setValue:(NSString *)string mode:(NSString *)mode parse:(BOOL)parse response:(PPSetValueResponse)response;

- (void)parse:(PPParseResponse)response mode:(NSString *)mode;

- (void)replaceCharactersWith:(NSString *)substring range:(NSRange)range mode:(NSString *)mode parseSubstring:(BOOL)parseSubstring response:(PPSetValueResponse)response;

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseSubstring:(BOOL)parseSubstring response:(PPSetValueResponse)response;

- (void)replaceCharactersWith:(NSString *)substring range:(NSRange)range mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response;

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response;

@end

//@protocol PPCodeMirrorProtocol <NSObject>
//
//@required
//
//- (void)setValue:(NSString *)string parse:(BOOL)parse response:(PPCodeMirrorResponse)response;
//
//@end
