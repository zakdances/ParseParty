//
//  OCSSAtRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPAtRuleSet.h"

@implementation PPAtRuleSet

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
