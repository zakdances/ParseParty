//
//  OCSSToken.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

// For your convenience, here's an alternative to isKindOfClass:
typedef NS_ENUM(NSUInteger, OCSSTokenType) {
    OCSSTokenTypeNil,
    OCSSTokenTypeOther,
    OCSSTokenTypeRule,
    OCSSTokenTypeAtRule,
    OCSSTokenTypeProperty,
    OCSSTokenTypeBlockComment
};

@interface OCSSToken : NSObject

@property OCSSTokenType cssTokenType;

@end
