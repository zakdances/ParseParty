//
//  OCSSRule.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPToken.h"

@interface PPRule : PPToken

@property (strong) NSAttributedString *selectorCSS;
@property (strong) NSMutableArray *blockContent;

+ (PPRule *)ruleWithSelector:(NSString *)selector andBlockContent:(NSArray *)blockContent;

@end
