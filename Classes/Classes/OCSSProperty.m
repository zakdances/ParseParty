//
//  OCSSProperty.m
//  Pods
//
//  Created by Zak.
//
//

#import "OCSSProperty.h"

@implementation OCSSProperty

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
