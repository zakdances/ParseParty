//
//  MTLFAttributedString.m
//  Pods
//
//  Created by Zak.
//
//

#import "jNSValueWithRange.h"
#import "NSValue+RangeWithDirection.h"

@implementation jNSValueWithRangeAndDirection

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
	keyPaths[@"rangeDirection"] = @"direction";
    return keyPaths.copy;
}



//- (NSColor *)object
//{
//	return [NSColor colorWithCalibratedRed:self.r green:self.g blue:self.b alpha:self.a];
//}


- (NSValue *)value
{
	NSValue *value = [super value];
	if ([self.class validRange:value.rangeValue]) {
		value.rangeDirection = self.rangeDirection;
	}
	
	return value;
}

+ (instancetype)modelWithValue:(NSValue *)value options:(jOption)options error:(NSError **)error;
{
	jNSValueWithRangeAndDirection *model = nil;
	
	NSError *error2;
	jNSValue *superModel = [super modelWithValue:value error:&error2];
	if (error2) NSLog(@"%@", error2);
	
	
	if ([superModel hasValidValueWithRange]) {
		model = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:@{@"location": @(superModel.location),
																	   @"length": @(superModel.length),
																	   @"direction":@(value.rangeDirection)} error:error];
	}
	
	if (model) {
		model.options = options;
	}

	return model;
}

//+ (instancetype)modelWithObject:(id)object error:(NSError *__autoreleasing *)error
//{
//	NSColor *color = object;
//
//	return [MTLJSONAdapter modelOfClass:self fromJSONDictionary:@{@"r": @(color.redComponent),
//																  @"g": @(color.greenComponent),
//																  @"b": @(color.blueComponent),
//																  @"a": @(color.alphaComponent)}
//								  error:error];
//}

+ (NSValueTransformer *)rangeDirectionJSONTransformer
{

	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *rangeDirectionJSON) {

		if ([rangeDirectionJSON isKindOfClass:NSString.class]) {
			NSString *string = (id)rangeDirectionJSON;
			rangeDirectionJSON = [string isEqualToString:@"up"] ? @(NSRangeDirectionUp) : @(NSRangeDirectionDown);
		}
        return rangeDirectionJSON;
		
    } reverseBlock:^(NSNumber *rangeDirection) {
        return rangeDirection;
    }];
}

- (NSDictionary *)JSONDictionary
{
	NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:self];
	
	if (self.options == jOptionPrettyPrinted) {
		
		NSMutableDictionary *JSONMutableDictionary = JSONDictionary.mutableCopy;
		NSRangeDirection direction = [JSONMutableDictionary[@"direction"] unsignedIntegerValue];

		JSONMutableDictionary[@"direction"] = direction == NSRangeDirectionUp ? @"up" : @"down";
		
//		TODO: Figure out my properties that aren't in JSONKeyPathsByPropertyKey are being serialized.
		[JSONMutableDictionary removeObjectForKey:@"options"];
		
		JSONDictionary = JSONMutableDictionary.copy;
	}
	return JSONDictionary;
}

@end
