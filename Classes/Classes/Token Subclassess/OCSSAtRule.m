//
//  OCSSAtRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "OCSSAtRule.h"

@implementation OCSSAtRule

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _cssTokenType = OCSSTokenTypeAtRule;
    }
    
    return self;
}

@end
