//
//  NSTextStorage+TextViewReference.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PPTTextView;

@interface NSTextStorage (TextViewReference)

@property (weak) PPTTextView *textView;

@end
