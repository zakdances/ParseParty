//
//  OCSSParser.h
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSOrderedDictionary/NSOrderedDictionary.h>
@class PKParser;

@interface OCSSParser : NSObject {
    __strong NSString *scssGrammar;
    __strong NSString *lessGrammar;
    __strong NSString *cssGrammar;
    
    __strong PKParser *scssParser;
    __strong PKParser *lessParser;
    __strong PKParser *cssParser;
}


+ (OCSSParser *)sharedParser;

- (void)parseTestStringToSCSS;

@end
