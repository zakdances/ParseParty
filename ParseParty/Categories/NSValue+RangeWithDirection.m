//
//  NSValue+Direction.m
//  ParseParty
//
//  Created by Zak.
//
//

#import "NSValue+RangeWithDirection.h"
//#import "jNSValueWithRange.h"
#import <objc/objc-runtime.h>


static void *rangeDirectionKey;

@implementation NSValue (Direction)

- (NSRangeDirection)rangeDirection
{
	NSNumber *rangeDirectionNumber = objc_getAssociatedObject(self, rangeDirectionKey);
	return rangeDirectionNumber ? rangeDirectionNumber.integerValue : NSRangeDirectionUp;
}

- (void)setRangeDirection:(NSRangeDirection)rangeDirection
{
	objc_setAssociatedObject(self, rangeDirectionKey, @(rangeDirection), OBJC_ASSOCIATION_RETAIN);
}


//- (NSDictionary *)toJSONFromValueWithRange:(NSError **)error options:(jNSValueOption)options
//{
//	NSString *jModelSubclassName = [self.class jModelSubclassName];
//	
//	jNSValue *jModel = [NSClassFromString(jModelSubclassName) modelWithValueWithRange:self error:error];
//	NSDictionary *JSONDictionary = [jModel JSONDictionary];
//
//	return JSONDictionary;
//	
//}
//
//+ (NSString *)jModelSubclassName
//{
//	return @"jNSValueWithRange";
//}
//
+ (instancetype)valueWithRange:(NSRange)range direction:(NSRangeDirection)direction
{
	NSValue *value = [self valueWithRange:range];
	value.rangeDirection = direction;
	return value;
}

- (BOOL)isEqualToRangeWithDirection:(NSValue *)valueWithRange
{
	if (![self isEqual:valueWithRange]) {
		return NO;
	}
	else {
//		NSRange range1 = self.rangeValue;
//		NSRange range2 = valueWithRange.rangeValue;
//		NSLog(@"range1 direction: %@", @(self.rangeDirection));
//		NSLog(@"range2 direction: %@", @(valueWithRange.rangeDirection));
		if (self.rangeDirection != valueWithRange.rangeDirection) {
			return NO;
		}
	}
	return YES;
}

@end
