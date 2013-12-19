//
//  OCSSProperty.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPProperty.h"

@implementation PPProperty

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _cssTokenType = OCSSTokenTypeProperty;
    }
    
    return self;
}

@end
