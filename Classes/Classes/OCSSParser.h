//
//  OCSSParser.h
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSOrderedDictionary/NSOrderedDictionary.h>
#import "OCSSRule.h"
#import "OCSSSelector.h"
@class PKParser;

typedef void (^ OCSSBlock)(NSSet *styleSheetModel, NSTreeController *styleSheetController);

@interface OCSSParser : NSObject {
    __strong NSString *scssGrammar;
    __strong NSString *lessGrammar;
    __strong NSString *cssGrammar;
    
    __strong PKParser *scssParser;
    __strong PKParser *lessParser;
    __strong PKParser *cssParser;
    
//    __strong NSMutableSet *_cssElems;
}


+ (OCSSParser *)sharedParser;

- (void)parseTestStringToSCSS;
- (void)testSCSS:(OCSSBlock)result;

@end
