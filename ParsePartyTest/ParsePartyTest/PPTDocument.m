//
//  PPTDocument.m
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPTDocument.h"
#import "PPTWindow.h"
// TODO: Find a way to avoid an extra import


@implementation PPTDocument

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
		
		
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"PPTDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
//	PPTWindow *window = (PPTWindow *)aController.window;
	self.sampleWindow = (PPTWindow *)aController.window;
	
	self.sampleWindow.output1.delegate = self;
	self.sampleWindow.output1.dataSource = self;
	self.sampleWindow.output2.textStorage.delegate = self;
	self.sampleWindow.output2.delegate = self;
	
	[self.sampleWindow.parseButton setAction:@selector(parseButtonAction:)];
	

	self.parser = [ParseParty parserWithCodeMirror:self.sampleWindow.input];
	
	self.parser.statusDelegate		= self;
//	parser.actionDelegate	= self;
//	parser.parseDelegate	= self;

	
	
//	NSTextStorage *textStorage = self.sampleWindow.output2.textStorage;
//	[textStorage beginEditing];
//	[textStorage replaceCharactersInRange:NSMakeRange(0, textStorage.string.length) withString:self.textStorage.string];
//	[textStorage endEditing];
	

	
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//	@throw exception;
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	// You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//	@throw exception;
	
	self.textStorage = [[NSTextStorage alloc] initWithData:data options:Nil documentAttributes:nil error:nil];


	return YES;
}

- (void)tokenize:(NSString *)string mode:(NSString *)mode
{
	[self.parser tokenize:string mode:mode response:^(NSArray *tokens) {
		self.tokens = tokens;
		
		[self.sampleWindow.output1 reloadData];
	}];
	
//	[[ParseParty sharedParser] tokenize:string mode:mode tokens:^(NSArray *tokens) {
//
//		
//
//	}];


}

//- (void)parseOutput
//{
////	[[ParseParty sharedParser] parse:self.sampleWindow.output2.attributedString success:^(NSAttributedString *newAttributedString) {
////		NSLog(@"here you go! %@", newAttributedString);
////	}];
//
//}

- (void)parseButtonAction:(id)sender
{
//	NSLog(@"Action!");
	ParseParty *parser = self.parser;
	
	NSRange range = NSMakeRange(0, parser.codeMirror.docLength);
	[parser parseRange:[NSRangePlus rangeWithRange:range] response:^(NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData) {
		
	}];
	
//	[parser parseRange:NSMakeRange(0, parser.codeMirror.docLength) response:^(NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData) {
//		[self didParse:range attributedString:attributedString tokens:tokens];
//	}];
}
//- (void)runAll
//{
//	[self tokenizeInput];
////	[self parseOutput];
//}

- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
	
//	[[ParseParty sharedParser] replaceCharactersWith:self.textStorage.string range:NSMakeRange(0, 0) mode:@"scss" parseSubstring:YES response:^(NSDictionary *responseData) {
//		
//	}];
	NSLog(@"ahha");
//	[[ParseParty sharedParser] replaceCharactersAt:NSMakeRange(0, 0) withCharacters:self.textStorage.string parseRange:NSMakeRange(0, self.textStorage.string.length) response:^(NSDictionary *responseData) {
//		
//	}];
	NSTextStorage *textStorage = notification.object;

	NSRange editedRange = textStorage.editedRange;
	NSInteger changeInLength = textStorage.changeInLength;
	
	NSAttributedString *attributedString = [textStorage attributedSubstringFromRange:editedRange];
//	if (range.length == 1) {
//		NSLog(@"editedSubstring: %@", [textStorage attributedSubstringFromRange:range].string);
//	}
//	NSLog(@"user info: %@", notification.userInfo);
//	NSLog(@"edited. TextView ready? %@", (self.sampleWindow.output2ready ? @"YES" : @"NO"));

	if (textStorage.textView.editSource == NSTextViewEditSourceKeyboard) {
		self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
		NSLog(@"heh");
		
		NSUInteger docLength = self.parser.codeMirror.docLength;
//		self.sampleWindow.output2ready = NO;
		NSInteger newLocation			= editedRange.location > docLength ? docLength : editedRange.location;
		NSInteger newLength				= editedRange.length - changeInLength;
		
		// NSRange newRange = NSMakeRange(newLocation, newLength);
		NSRange range = NSIntersectionRange( NSMakeRange(newLocation, newLength), NSMakeRange(0, docLength) );
		NSRange parseRange = NSMakeRange(editedRange.location, attributedString.length);
		
//		[[ParseParty sharedParser] replaceCharactersAt:range
//										withCharacters:attributedString.string
//										thenParseRange:parseRange
//											  response:^(NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData)
//		{
//
//			
//			[textStorage beginEditing];
//			[textStorage replaceCharactersInRange:range withAttributedString:attributedString];
//			[textStorage endEditing];
//			
//			[textStorage.textView setSelectedRanges:@[[NSValue valueWithRange:NSMakeRange(0, 0)]] affinity:NSSelectionAffinityDownstream stillSelecting:NO];
//			self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
//		}];

	}

}

- (void)textViewDidChangeSelection:(NSNotification *)aNotification
{
	if (self.parser.status == PPStatusReady && self.shouldReportSelectionAndInsertionPointChangesToParser) {
		NSTextView *textView = aNotification.object;
		NSRange selectedRange = textView.selectedRange;
		NSSelectionAffinity affinity = textView.selectionAffinity;
		NSString *affinityString = affinity == NSSelectionAffinityUpstream ? @"up" : @"down";

		NSAttributedRange *selectedAttributedRange = [NSAttributedRange attributedRangeWithRange:selectedRange attributes:@{@"affinity":affinityString}];
//		[[ParseParty sharedParser] setSelections:@[[NSValue valueWithRange:selectedRange]] response:^(NSArray *selections, NSDictionary *responseData) {
//			NSLog(@"selection changed range: %@", selections);
//		}];
		
		
		[self.parser selectedAttributedRanges:@[selectedAttributedRange] response:^(NSArray *selectedAttributedRanges, id responseData) {
			NSLog(@"selection changed range: %@", selectedAttributedRanges);
		}];
	}
}


- (void)parserAction:(NSDictionary *)data
{
	
}

- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens
{
	self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
//	NSLog(@"did parse");
	NSTextStorage *textStorage = self.sampleWindow.output2.textStorage;
	
//	NSRange er = NSMakeRange(0, attributedString.length);
//	NSDictionary *rangeData = [attributedString attribute:@"globalRange" atIndex:0 effectiveRange:&er];
	
	NSRange range1 = globalRange;
	NSRange range2 = NSIntersectionRange(range1, NSMakeRange(0, textStorage.length));
//	NSLog(@"%@ %@", NSStringFromRange(range1), NSStringFromRange(range2));

//	NSLog(@"RV: %@", NSStringFromRange(range));
	
	[textStorage beginEditing];
	[textStorage replaceCharactersInRange:range2 withAttributedString:attributedString];
	[textStorage endEditing];

	self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
}

// When parser loads, then do this.
- (void)parserStatusDidChangeTo:(PPStatus)newStatus from:(PPStatus)oldStatus parser:(ParseParty *)parser
{
//	__weak ParseParty *weakParser = parser;
	__weak PPTDocument *weakSelf = self;
	
	NSLog(@"Parser status changed to \"%@\" from \"%@\".", @(newStatus), @(oldStatus));
	if (newStatus == PPStatusReady && oldStatus == PPStatusUnloaded) {
			
		NSString *mode = @"scss";
		
		[parser beginRequest];
		
		[parser mode:mode response:nil];
		[parser replaceCharactersAt:[NSRangePlus rangeWithLocation:0 length:0] withCharacters:self.textStorage.string response:nil];
		[parser parseRange:[NSRangePlus rangeWithLocation:0 length:self.textStorage.string.length] response:nil];
		
		[parser endRequest:^(NSArray *compoundResponseData) {
			__strong PPTDocument *strongSelf = weakSelf;
			
			NSDictionary *parseRangeData = compoundResponseData[2];
			
			NSAttributedString *attributedString = parseRangeData[@"attributedString"];
			NSArray *tokens = parseRangeData[@"tokens"];
			// TODO: Make sure this attributed is unserialized correctly
			NSRangePlus *globalRange = [attributedString attribute:@"globalRange" atIndex:0 effectiveRange:nil];
			
			[strongSelf didParse:globalRange.range attributedString:attributedString tokens:tokens];
		}];
		
	}
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

	return self.tokens.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

	// Retrieve to get the @"MyView" from the pool
	// If no version is available in the pool, load the Interface Builder version
	NSTableCellView *result = [tableView makeViewWithIdentifier:@"eee" owner:self];
	NSDictionary *data = [self.tokens objectAtIndex:row];

	// or as a new cell, so set the stringValue of the cell to the
	// nameArray value at row
	if ([tableColumn.identifier isEqualToString:@"first"]) {
		result = [tableView makeViewWithIdentifier:@"eee" owner:self];
		NSString *label = data[@"text"] ? : @"ERROR: MISSING TEXT";
		result.textField.stringValue = label;
	}
	else if ([tableColumn.identifier isEqualToString:@"second"]) {
		result = [tableView makeViewWithIdentifier:@"ccc" owner:self];
		NSString *label = data[@"styleClass"] ? : @"ERROR: MISSING STYLE CLASS";
		result.textField.stringValue = label;
	}
	else if ([tableColumn.identifier isEqualToString:@"third"]) {
		result = [tableView makeViewWithIdentifier:@"ccc" owner:self];
		NSString *label = data[@"state"] ? : @"ERROR: MISSING STYLE CLASS";
		result.textField.stringValue = label;
	}


	// return the result.
	return result;
}

@end
