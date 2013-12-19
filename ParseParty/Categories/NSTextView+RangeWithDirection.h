//
//  NSText+SelectedRangesWithDirections.h
//  Pods
//
//  Created by Zak.
//
//

#import <Cocoa/Cocoa.h>

@interface NSTextView (SelectedRangesWithDirections)

- (NSArray *)selectedRangesWithDirections;

- (void)setSelectedRangesWithDirections:(NSArray *)rangesWithDirections;

- (void)setSelectedRangesWithDirections:(NSArray *)rangesWithDirections stillSelecting:(BOOL)stillSelecting;

@end
