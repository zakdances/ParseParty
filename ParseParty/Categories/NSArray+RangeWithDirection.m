//
//  NSArray+RangeWithDirection.m
//  Pods
//
//  Created by Zak.
//
//

#import "NSArray+RangeWithDirection.h"
#import "NSValue+RangeWithDirection.h"

@implementation NSArray (RangeWithDirection)

- (BOOL)isEqualToArrayOfRangesWithDirections:(NSArray *)otherArray
{
	if (self.count != otherArray.count) {
		return NO;
	}
	for (int i = 0; i < self.count; i++) {
		NSValue *valueWithRangeAndDirection1 = self[i];
		NSValue *valueWithRangeAndDirection2 = otherArray[i];
		
		if (![valueWithRangeAndDirection1 isEqualToRangeWithDirection:valueWithRangeAndDirection2]) {
			return NO;
		}
	};
	
	return YES;
}

@end
