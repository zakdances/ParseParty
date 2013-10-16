//
//  OCSSRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "OCSSRule.h"

@implementation OCSSRule

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _cssTokenType = OCSSTokenTypeRule;
    }
    
    return self;
}

+ (OCSSRule *)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent
{
    OCSSRule *rule = [OCSSRule new];
    rule.selectorCSS = [[NSAttributedString alloc] initWithString:selector];
    rule.blockContent = blockContent ? blockContent.mutableCopy : @[].mutableCopy ;
    
    return rule;
}

@end
