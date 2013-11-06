//
//  PPTWindow.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseParty/ParseParty.h>
#import "PPTTextView.h"

@interface PPTWindow : NSWindow

@property (weak) IBOutlet PPCodeMirror *input;
@property (weak) IBOutlet NSTableView *output1;
@property (strong) IBOutlet PPTTextView *output2;
@property (weak) IBOutlet NSButton *parseButton;
//@property BOOL output2ready;

@end
