//
//  OCSSRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPRule.h"

@implementation PPRule

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _cssTokenType = OCSSTokenTypeRule;
    }
    
    return self;
}

+ (PPRule *)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent
{
    PPRule *rule = [PPRule new];
    rule.selectorCSS = [[NSAttributedString alloc] initWithString:selector];
    rule.blockContent = blockContent ? blockContent.mutableCopy : @[].mutableCopy ;
    
    return rule;
}

@end
