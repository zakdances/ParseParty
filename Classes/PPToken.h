//
//  OCSSToken.h
//  Objective-CSS
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

// For your convenience, here's an alternative to isKindOfClass:
typedef NS_ENUM(NSInteger, OCSSTokenType) {
    OCSSTokenTypeToken, // You should never see this (it's the root class)
    OCSSTokenTypeRule,
    OCSSTokenTypeAtRule,
    OCSSTokenTypeSelector,
    OCSSTokenTypeDeclarationBlock,
    OCSSTokenTypeProperty,
    OCSSTokenTypeBlockComment
};

@interface PPToken : NSObject {
    OCSSTokenType _cssTokenType;
}

@property (readonly) OCSSTokenType cssTokenType;

@end
