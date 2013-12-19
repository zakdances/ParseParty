//
//  OCSSRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPRuleSet.h"

@implementation PPRuleSet

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _cssTokenType = OCSSTokenTypeRule;
    }
    
    return self;
}

+ (instancetype)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent
{
    PPRuleSet *rule = [self new];
    rule.selectorCSS = [[NSAttributedString alloc] initWithString:selector];
    rule.blockContent = blockContent ? blockContent.mutableCopy : @[].mutableCopy ;
    
    return rule;
}

@end
