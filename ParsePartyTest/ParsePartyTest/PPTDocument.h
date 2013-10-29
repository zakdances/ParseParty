//
//  PPTDocument.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseParty/ParseParty.h>

@class PPTWindow;

@interface PPTDocument : NSDocument <PPLoadDelegate, PPActionDelegate, NSTextStorageDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSTextStorage *textStorage;
@property (weak) PPTWindow *sampleWindow;

@property (strong) NSArray *tokens;

@end
