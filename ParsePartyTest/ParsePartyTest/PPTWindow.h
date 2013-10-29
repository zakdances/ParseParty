//
//  PPTWindow.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseParty/ParseParty.h>

@interface PPTWindow : NSWindow

@property (weak) IBOutlet PPCodeMirror *input;
@property (weak) IBOutlet NSTableView *output1;
@property (strong) IBOutlet NSTextView *output2;

@end
