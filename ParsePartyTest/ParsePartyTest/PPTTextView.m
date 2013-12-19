//
//  PPTTextView.m
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPTTextView.h"

@implementation PPTTextView

- (id)init
{
    self = [super init];
    if (self) {
//        self.textStorage.textView = self;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

//- (void)insertText:(id)aString replacementRange:(NSRange)replacementRange
//{
//	self.editSource = NSTextViewEditSourceKeyboard;
////	if ([self.delegate respondsToSelector:@selector(willInsertTextInTextView:newText:replacementRange:)]) {
////		[self.delegate willInsertTextInTextView:self newText:aString replacementRange:replacementRange];
////	}
////	else {
//		[super insertText:aString replacementRange:replacementRange];
////	}
////	self.editSource = NSTextViewEditSourceNone;
//}
//
//- (void)setMarkedText:(id)aString selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange
//{
//	self.editSource = NSTextViewEditSourcePaste;
////	if ([self.delegate respondsToSelector:@selector(willSetMarkedTextIn:newText:selectedRange:replacementRange:)]) {
////		[self.delegate willSetMarkedTextIn:self newText:aString selectedRange:selectedRange replacementRange:replacementRange];
////	}
////	else {
//	[super setMarkedText:aString selectedRange:selectedRange replacementRange:replacementRange];
////	}
//	self.editSource = NSTextViewEditSourceNone;
//}
//
//- (void)doCommandBySelector:(SEL)aSelector
//{
////	NSLog(@"textview command: %@", NSStringFromSelector(aSelector));
//	NSString *selString = NSStringFromSelector(aSelector);
//	
//	if ([selString isEqualToString:@"deleteBackward:"]) {
//		self.editSource = NSTextViewEditSourceDeleteBackward;
//	}
//	else {
//		self.editSource = NSTextViewEditSourceOtherCommand;
//	}
//
//	[super doCommandBySelector:aSelector];
////	}
//	self.editSource = NSTextViewEditSourceNone;
//}

- (NSTextStorage *)textStorage
{
	// TODO: Make sure delegate is assigned if textStorage is replaced.
	NSTextStorage *textStorage = super.textStorage;
//	if (![textStorage.textView isEqual:self]) textStorage.textView = self;
	return textStorage;
}


//- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange granularity:(NSSelectionGranularity)granularity
//{
//	NSLog(@"selectionRangeForProposedRange: fired %@", NSStringFromRange(proposedSelRange));
//	return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
//}


- (void)setSelectedRanges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag
{

//	Get current state of textview.
	NSArray *currentlySelectedRanges = self.selectedRanges;
	NSSelectionAffinity currentAffinity = self.selectionAffinity;
	
	BOOL areRangesTheSame = [ranges isEqualToArray:currentlySelectedRanges];
	BOOL should = YES;
	BOOL respondsToShould = [self.delegate respondsToSelector:@selector(textView:shouldChangeSelectionFromCharacterRanges:fromAffinity:toCharacterRanges:toAffinity:stillSelecting:)];
	BOOL respondsToWill		= [self.delegate respondsToSelector:@selector(textView:willChangeSelectionFromCharacterRanges:fromAffinity:toCharacterRanges:toAffinity:stillSelecting:)];
	BOOL respondsToDid		= [self.delegate respondsToSelector:@selector(textView:didChangeSelectionFromCharacterRanges:fromAffinity:toCharacterRanges:toAffinity:stillSelecting:)];

	
	if (respondsToShould && !areRangesTheSame) {
		
		should = [self.delegate textView:self shouldChangeSelectionFromCharacterRanges:currentlySelectedRanges fromAffinity:currentAffinity toCharacterRanges:ranges toAffinity:affinity stillSelecting:stillSelectingFlag];
	}

	if (should) {
		
		if ( respondsToWill ) {
			
			ranges = [self.delegate textView:self
	  willChangeSelectionFromCharacterRanges:currentlySelectedRanges
								fromAffinity:currentAffinity
						   toCharacterRanges:ranges
								  toAffinity:affinity
							  stillSelecting:stillSelectingFlag];
		}
	
	
	
		[super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
		
		areRangesTheSame = [self.selectedRanges isEqualToArray:currentlySelectedRanges];
		
		if (respondsToDid && !areRangesTheSame) {
			
	//		currentlySelectedRanges = self.selectedRanges;
	//		currentAffinity = self.selectionAffinity;
			
			[self.delegate textView:self
	didChangeSelectionFromCharacterRanges:currentlySelectedRanges
					   fromAffinity:currentAffinity
				  toCharacterRanges:self.selectedRanges
						 toAffinity:self.selectionAffinity
					 stillSelecting:stillSelectingFlag];
		}
	}
}

@end
