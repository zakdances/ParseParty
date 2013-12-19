//
//  PPTDocument.h
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ParseParty/ParseParty.h>
//#import <ParseParty/PPParseProtocol.h>
#import "PPTWindow.h"

@interface PPTDocument : NSDocument <PPDelegate, NSTextStorageDelegate, NSTextViewPlusDelegate, NSTableViewDelegate, NSTableViewDataSource> {
//	BOOL _shouldTextViewChangeSelectedRanges;
//	BOOL _shouldReplaceRange;
}

@property (strong) ParseParty *parser;
@property (strong) MGITRepository *repo;

@property (strong)	NSTextStorage	*textStorage;
//@property (strong) NSMapTable *premadeCommits;
@property (weak)	PPTWindow		*w;

//@property BOOL shouldReportSelectionAndInsertionPointChangesToParser;
@property (strong) NSArray *tokens;

@end
