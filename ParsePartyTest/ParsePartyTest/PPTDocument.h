//
//  PPTDocument.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseParty/ParseParty.h>
#import <ParseParty/PPParseProtocol.h>
@class PPTWindow;

@interface PPTDocument : NSDocument <PPStatusDelegate, NSTextStorageDelegate, NSTextViewDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong) ParseParty *parser;

@property (strong)	NSTextStorage	*textStorage;
@property (weak)	PPTWindow		*sampleWindow;
@property BOOL shouldReportSelectionAndInsertionPointChangesToParser;
@property (strong) NSArray *tokens;

@end
