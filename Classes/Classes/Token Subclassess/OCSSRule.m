//
//  OCSSRule.m
//  Pods
//
//  Created by Zak.
//
//

#import "OCSSRule.h"

@implementation OCSSRule

+ (OCSSRule *)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent
{
    OCSSRule *rule = [OCSSRule new];
    rule.selector = [[NSAttributedString alloc] initWithString:selector];
    rule.blockContent = blockContent ? blockContent.mutableCopy : @[].mutableCopy ;
    
    return rule;
}

@end
