//
//  OCSSParser.h
//  Objective-CSS
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRule.h"
#import "PPSelector.h"
@class PKParser;

typedef void (^ OCSSBlock)(NSSet *styleSheetModel, NSTreeController *styleSheetController);

@interface _PPParser : NSObject {
//    __strong NSString *scssGrammar;
//    __strong NSString *lessGrammar;
//    __strong NSString *cssGrammar;
//    
//    __strong PKParser *scssParser;
//    __strong PKParser *lessParser;
//    __strong PKParser *cssParser;
    
//    __strong NSMutableSet *_cssElems;
}


//+ (PPParser *)sharedParser;

//- (void)parseTestStringToSCSS;
//- (void)testSCSS:(OCSSBlock)result;

@end
