//
//  PPTTextView.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextStorage+TextViewReference.h"

typedef NS_ENUM(NSUInteger, NSTextViewEditSource) {
    NSTextViewEditSourceNone,
    NSTextViewEditSourceKeyboard,
	NSTextViewEditSourcePaste,
    NSTextViewEditSourceOtherCommand
};

@protocol NSTextViewPlusDelegate <NSObject, NSTextViewDelegate>

@optional

- (void)willInsertTextInTextView:(NSTextView *)textView newText:(id)aString replacementRange:(NSRange)replacementRange;

- (void)willSetMarkedTextIn:(NSTextView *)textView newText:(id)aString selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange;

- (void)willDoCommandOnTextView:(NSTextView *)textView selector:(SEL)aSelector;

@end

@interface PPTTextView : NSTextView

// Notify the delegate when changes are generated via keyboard, not copy paste.
@property BOOL textInsertedWithKeyboard;
@property NSTextViewEditSource editSource;
@property (weak) id <NSTextViewPlusDelegate> delegate;

@end
