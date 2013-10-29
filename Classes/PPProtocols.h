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

@protocol PPActionDelegate <NSObject>

@optional

- (void)parserAction:(NSDictionary *)data;

@end

typedef void (^PPTokensBlock) (NSArray *tokens);

@protocol PPTokenize <NSObject>

@required

- (void)tokenize:(NSString *)string tokens:(PPTokensBlock)tokensBlock;

@end

