//
//  OCSSAtRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPAtRule.h"

@implementation PPAtRule

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
