//
//  NSText+SelectedRangesWithDirections.m
//  Pods
//
//  Created by Zak.
//
//

#import "NSTextView+RangeWithDirection.h"
#import "NSValue+RangeWithDirection.h"

@implementation NSTextView (SelectedRangesWithDirections)

- (NSArray *)selectedRangesWithDirections
{
	NSSelectionAffinity affinity = self.selectionAffinity;
	
	NSMutableArray *rangeValues = self.selectedRanges.mutableCopy;
	for (int i = 0; i < rangeValues.count; i++) {
		NSValue *value = rangeValues[i];
		value.rangeDirection = affinity ? NSRangeDirectionUp : NSRangeDirectionDown;
	};
	
	return rangeValues.copy;
}

- (void)setSelectedRangesWithDirections:(NSArray *)rangesWithDirections;
{
//	NSSelectionAffinity affinity = [rangesWithDirections[0] rangeDirection];
//	self.selectedRanges = rangesWithDirections;
	[self setSelectedRangesWithDirections:rangesWithDirections stillSelecting:NO];
//	TODO: Figure out "affinity"
}

- (void)setSelectedRangesWithDirections:(NSArray *)rangesWithDirections stillSelecting:(BOOL)stillSelecting
{
	// Make sure direction of selections are correct even if length is zero because NSTextView seems to ignore affinity on such selections.
//	NSMutableArray *mutableRangesAndDirections = rangesWithDirections.mutableCopy;
//	for (int i = 0; i < mutableRangesAndDirections.count; i++) {
//		
//		NSValue *valueWithRangeAndDirection = mutableRangesAndDirections[i];
//		NSRange range = valueWithRangeAndDirection.rangeValue;
//		NSRangeDirection direction = valueWithRangeAndDirection.rangeDirection;
//		
//		if (range.location > 0 && range.length == 0 && direction == NSRangeDirectionUp) {
//			range.location = range.location - 1;
//			[mutableRangesAndDirections replaceObjectAtIndex:i withObject:[NSValue valueWithRange:range direction:direction]];
//		}
//	};
//	rangesWithDirections = mutableRangesAndDirections.copy;

	
	NSSelectionAffinity affinity = [rangesWithDirections[0] rangeDirection] == NSRangeDirectionUp ? NSSelectionAffinityUpstream : NSSelectionAffinityDownstream;
//	NSLog(@"selection affinity: %@", affinity == NSSelectionAffinityUpstream ? @"Upstream" : @"Downstream");
	[self setSelectedRanges:rangesWithDirections affinity:affinity stillSelecting:stillSelecting];
	
}

@end
