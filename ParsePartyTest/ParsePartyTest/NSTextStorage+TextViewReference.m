//
//  NSTextStorage+TextViewReference.m
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "NSTextStorage+TextViewReference.h"
#import "PPTTextView.h"
#import <objc/runtime.h>

static void *textViewKey;

@implementation NSTextStorage (TextViewReference)

- (PPTTextView *)textView
{
	return objc_getAssociatedObject(self, textViewKey);
}

- (void)setTextView:(PPTTextView *)textView
{
	objc_setAssociatedObject(self, textViewKey, textView, OBJC_ASSOCIATION_ASSIGN);
}

@end
