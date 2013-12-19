//
//  PPTTextView.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextStorage+TextViewReference.h"

//typedef NS_ENUM(NSUInteger, NSTextViewEditSource) {
//    NSTextViewEditSourceNone,
//    NSTextViewEditSourceKeyboard,
//	NSTextViewEditSourcePaste,
//	NSTextViewEditSourceDeleteBackward,
//    NSTextViewEditSourceOtherCommand
//};

@protocol NSTextViewPlusDelegate <NSTextViewDelegate>

@optional

- (BOOL)textView:(PPTTextView *)aTextView shouldChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag;

- (NSArray *)textView:(PPTTextView *)aTextView willChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag;

- (void)textView:(PPTTextView *)aTextView didChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag;

@end

@interface PPTTextView : NSTextView

// Notify the delegate when changes are generated via keyboard, not copy paste.
//@property BOOL textInsertedWithKeyboard;

//@property NSTextViewEditSource editSource;

@property (weak) id <NSTextViewPlusDelegate> delegate;

//@property (strong) MGITCommit *premadeCommit;

@end
