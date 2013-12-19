//
//  NSValue+Direction.h
//  ParseParty
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
//#import <Jantle/Jantle.h>

typedef NS_ENUM(NSUInteger, NSRangeDirection) {
    NSRangeDirectionUp,
    NSRangeDirectionDown
};

@interface NSValue (Direction)

@property NSRangeDirection rangeDirection;

//- (NSDictionary *)toJSONFromValueWithRange:(NSError **)error options:(jNSValueOption)options;
//
+ (NSValue *)valueWithRange:(NSRange)range direction:(NSRangeDirection)direction;

- (BOOL)isEqualToRangeWithDirection:(NSValue *)valueWithRange;

@end
