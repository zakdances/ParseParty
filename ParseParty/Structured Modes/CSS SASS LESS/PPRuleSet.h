//
//  OCSSRule.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPToken.h"

@interface PPRuleSet : PPToken

@property (strong) NSAttributedString *selectorCSS;
@property (strong) NSMutableArray *blockContent;

+ (instancetype)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent;

@end
