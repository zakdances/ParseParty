//
//  MTLFAttributedString.h
//  Pods
//
//  Created by Zak.
//
//

#import <Jantle/jNSValue.h>

typedef NS_ENUM(NSUInteger, jOption) {
	jOptionUnformatted,
    jOptionPrettyPrinted
};

@interface jNSValueWithRangeAndDirection : jNSValue <JantleModel>

//@property NSUInteger location;
//@property NSUInteger length;

// TODO: Why does this have to be NSUInteger to avoid circular import?
@property NSUInteger rangeDirection;

@property jOption options;
//- (NSValue *)valueWithRange;
//
+ (instancetype)modelWithValue:(NSValue *)value options:(jOption)options error:(NSError **)error;

@end
