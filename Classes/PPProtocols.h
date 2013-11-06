//
//  PPProtocols.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
@class ParseParty;

@protocol PPLoadDelegate <NSObject>

@optional

- (void)parserLoaded:(ParseParty *)parser;

@end

@protocol PPActionDelegate <NSObject, PPLoadDelegate>

@optional

- (void)parserAction:(NSDictionary *)data;

@end

typedef void (^PPTokensBlock) (NSArray *tokens);

@protocol PPTokenize <NSObject>

@required

- (void)tokenize:(NSString *)string mode:(NSString *)mode tokens:(PPTokensBlock)tokensBlock;

@end

