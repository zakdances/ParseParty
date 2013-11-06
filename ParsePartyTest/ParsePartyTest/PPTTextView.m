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
        self.textStorage.textView = self;
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

- (void)insertText:(id)aString replacementRange:(NSRange)replacementRange
{
	self.editSource = NSTextViewEditSourceKeyboard;
	if ([self.delegate respondsToSelector:@selector(willInsertTextInTextView:newText:replacementRange:)]) {
		[self.delegate willInsertTextInTextView:self newText:aString replacementRange:replacementRange];
	}
	else {
		[super insertText:aString replacementRange:replacementRange];
	}
	self.editSource = NSTextViewEditSourceNone;
}

- (void)setMarkedText:(id)aString selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange
{
	self.editSource = NSTextViewEditSourcePaste;
	if ([self.delegate respondsToSelector:@selector(willSetMarkedTextIn:newText:selectedRange:replacementRange:)]) {
		[self.delegate willSetMarkedTextIn:self newText:aString selectedRange:selectedRange replacementRange:replacementRange];
	}
	else {
		[super setMarkedText:aString selectedRange:selectedRange replacementRange:replacementRange];
	}
	self.editSource = NSTextViewEditSourceNone;
}

- (void)doCommandBySelector:(SEL)aSelector
{
	self.editSource = NSTextViewEditSourceOtherCommand;
	if ([self.delegate respondsToSelector:@selector(willDoCommandOnTextView:selector:)]) {
		[self.delegate willDoCommandOnTextView:self selector:aSelector];
	}
	else {
		[super doCommandBySelector:aSelector];
	}
	self.editSource = NSTextViewEditSourceNone;
}

- (NSTextStorage *)textStorage
{
	// TODO: Make sure delegate is assigned if textStorage is replaced.
	NSTextStorage *textStorage = super.textStorage;
	if (![textStorage.textView isEqual:self]) {
		textStorage.textView = self;
	}
	return textStorage;
}

@end
