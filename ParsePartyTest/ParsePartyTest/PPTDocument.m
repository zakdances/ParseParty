//
//  PPTDocument.m
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "PPTDocument.h"
#import "PPTWindow.h"
//#import <ParseParty/ParseParty.h>
// TODO: Find a way to avoid an extra import


@implementation PPTDocument

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
//		_shouldTextViewChangeSelectedRanges = YES;
//		_shouldReplaceRange = YES;
		self.repo = [MGITRepository repositoryWithCapacity:100];
//		self.premadeCommits = [NSMapTable weakToStrongObjectsMapTable];
		
		NSURL *url = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"scss"];
		
		[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
			NSLog(@"Sample doc loaded.");
		}];
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
	

	self.w = (PPTWindow *)aController.window;
	
	NSTextView *textView;
	
	textView = self.w.output2;
	textView.textStorage.delegate = self;
	[textView.textStorage.changeFactory setSource:@"textStorage" strength:MGITCommitSourceStrengthStrong];
	textView.delegate = self;
	[textView.changeFactory setSource:@"textView" strength:MGITCommitSourceStrengthStrong];

	self.w.output1.delegate = self;
	self.w.output1.dataSource = self;

	
	
//	[self.premadeCommits setObject:NSNull.null forKey:self.w.output2];
//	[self.premadeCommits setObject:NSNull.null forKey:self.w.output2.textStorage];
	
	[self.w.parseButton setAction:@selector(parseButtonAction:)];
	self.parser = [ParseParty parserWithCodeMirror:self.w.input];
	self.parser.delegate = self;

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
	NSError *error;
	self.textStorage = [[NSTextStorage alloc] initWithData:data options:nil documentAttributes:nil error:&error];
	if (error) NSLog(@"%@", error.localizedDescription);

	return YES;
}

- (void)tokenize:(NSString *)string mode:(NSString *)mode
{
	[self.parser tokenize:string mode:mode response:^(NSArray *tokens, NSError *error) {
		if (error) return NSLog(@"%@", error.localizedDescription);
		
		self.tokens = tokens;
		[self.w.output1 reloadData];
	}];

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
	
	NSRange range = NSMakeRange(0, 999999999);
	[parser parseRange:range commit:nil response:^(NSArray *tokens, NSRange range, MGITCommit *commit, NSError *error) {
		if (error) return NSLog(@"%@", error.localizedDescription);
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

	NSTextStorage *textStorage = notification.object;
	MGITCommit *commit = [textStorage.changeFactory nextCommit];
	[self.repo addAndCommitChange:commit];
//	MGITCommit *commit = self.repo add
//	if ((editSource == NSTextViewEditSourceKeyboard || editSource == NSTextViewEditSourceDeleteBackward) && self.shouldReportSelectionAndInsertionPointChangesToParser) {
	if ([commit.source isEqualToString:@"textStorage"]) {
		NSLog(@"A new change came from textStorage. Sending back to ParseParty...");
//		self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
		
		NSRange editedRange						= textStorage.editedRange;
		NSInteger changeInLength				= textStorage.changeInLength;
//		NSAttributedString *attributedString	= [textStorage attributedSubstringFromRange:editedRange];
		NSRange rrr = NSMakeRange(editedRange.location, changeInLength >= 0 ? changeInLength : 0);
//		NSAttributedString *attributedString	= [textStorage attributedSubstringFromRange:NSMakeRange(editedRange.location, changeInLength >= 0 ? changeInLength : 0)];

		

		NSLog(@"change in length: %@", @(changeInLength));
		
		NSUInteger previousTotalLength = textStorage.length - changeInLength;
//		NSUInteger	newLocation			= editedRange.location;
//		NSUInteger newLength				= editedRange.length - changeInLength;
		NSInteger	_newLength		= rrr.length - changeInLength;
		NSUInteger	newLength			= _newLength >= 0 ? _newLength : 0;
		
		NSRange _rrr = NSMakeRange(editedRange.location, newLength);
		
		NSRange range = NSMakeRange(NSNotFound, NSNotFound);
		if (_rrr.location == previousTotalLength && _rrr.length == 0) {
			range = _rrr;
		}
		else {
			range = NSIntersectionRange( _rrr, NSMakeRange(0, textStorage.length - changeInLength) );
		}
//			NSRange parseRange = editedRange;
//		if (changeInLength <= -3) {
		NSLog(@"thats odd: %@ %@ %@", NSStringFromRange(range), NSStringFromRange(_rrr), NSStringFromRange(NSMakeRange(0, previousTotalLength)));
//		}
		
//		[self.parser beginRequest];
		[self.parser range:range string:[textStorage.string substringWithRange:rrr] commit:nil response:nil];
//			[strongSelf.parser parseRange:parseRange response:nil];
//			[strongSelf.parser selectedRanges:nil response:nil];
//		[self.parser endRequest:^(NSArray *compoundResponseData) {
//			
//
//		}];
//		}];


	}

}

//- (NSRange)textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange
//{
//	NSLog(@"WELL I NEVER1!!!!");
//	return newSelectedCharRange;
//}
//- (NSArray *)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges toCharacterRanges:(NSArray *)newSelectedCharRanges
//{
//	NSLog(@"WELL I NEVER2!!!!");
//	return newSelectedCharRanges;
//}

- (BOOL)textView:(PPTTextView *)aTextView shouldChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag
{
	return ![self.repo findChangeOrCommitWithID:[self.w.output2.changeFactory nextCommit].id];
}

- (NSArray *)textView:(PPTTextView *)aTextView willChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag
{
	return newSelectedCharRanges;
}

- (void)textView:(PPTTextView *)aTextView didChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges fromAffinity:(NSSelectionAffinity)oldAffinity toCharacterRanges:(NSArray *)newSelectedCharRanges toAffinity:(NSSelectionAffinity)newAffinity stillSelecting:(BOOL)stillSelectingFlag
{
//	NSLog(@"textViewDidChangeSelections: to %@ %@ %@", newSelectedCharRanges, newAffinity == NSSelectionAffinityUpstream ? @"Upstream" : @"Downstream", [aTextView.textStorage.string substringWithRange:[newSelectedCharRanges[0] rangeValue]]);
//	NSLog(@"TextView selection changed.");
	if (self.w.firstResponder == self.w.output2) {
		
		NSArray *selectedRanges = aTextView.selectedRangesWithDirections;
//		for (NSValue *valueWithRange in selectedRanges) {
//			NSLog(@"selected ranges outgoing: %@", @(valueWithRange.rangeDirection));
//		}
		
		[self.parser selectedRanges:selectedRanges commit:nil response:^(NSArray *selectedRanges, NSArray *oldSelectedRanges, MGITCommit *commit, NSError *error) {
//			NSLog(@"CodeMirror selection was changed. New CodeMirror selected ranges: %@", selectedRanges);
			if (error) return NSLog(@"%@", error.localizedDescription);
		}];
	}
	else {
//		NSLog(@"TextView is not first responder.");
	}
}

//- (void)textViewDidChangeSelections:(PPTTextView *)textView ranges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag
//{
//	NSLog(@"textViewDidChangeSelections: to %@ %@", ranges, textView.selectionAffinity == NSSelectionAffinityUpstream ? @"Upstream" : @"Downstream" );
//	
//	if (self.shouldReportSelectionAndInsertionPointChangesToParser && self.parser.status == PPStatusReady) {
//
//		[self.parser selectedRanges:textView.selectedRangesWithDirections response:^(NSArray *selectedRanges, NSArray *oldSelectedRanges) {
//			NSLog(@"selection changed range. CM selected ranges: %@", selectedRanges);
//		}];
//	}
//}

//- (void)parserAction:(NSDictionary *)data
//{
//	
//}


// When parser loads, then do this.
- (void)parserStatusDidChangeTo:(PPStatus)newStatus from:(PPStatus)oldStatus parser:(ParseParty *)parser
{
	__weak PPTDocument *weakSelf = self;
	
//	NSLog(@"Parser status changed from %@ to %@.", [ParseParty statusToString:oldStatus], [ParseParty statusToString:newStatus]);
	
	if (newStatus == PPStatusReady && oldStatus == PPStatusUnloaded) {
	
//		self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
		
		NSString *mode = @"scss";

		[parser mode:mode response:nil];
		[parser range:NSMakeRange(0, 0) string:self.textStorage.string commit:nil response:^(NSString *string, NSString *oldString, NSRange range, MGITCommit *commit, NSError *error) {
//			self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
		}];
		
	}
}


- (void)parserDidChangeSelectedRangesTo:(NSArray *)rangesWithDirections from:(NSArray *)oldRangesWithDirections commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		if (error) {
			NSLog(@"parserDidChangeSelectedRangesTo: ERROR: %@", error.localizedDescription);
			return;
		}

		NSTextView *textView = self.w.output2;
		BOOL areRangesEqual = [rangesWithDirections isEqualToArrayOfRangesWithDirections:textView.selectedRangesWithDirections];
		
//		NSLog(@"parserDidChangeSelectedRanges: %@ %@ %@", textView.selectedRangesWithDirections, selectedRanges, @(areRangesEqual));
	//	NSLog(@"TextView range: %@", NSStringFromRange(NSMakeRange(0, textView.textStorage.length)));
//		NSLog(@"am Equal: %@", @([textView.selectedRanges isEqualToArray:selectedRanges]));
		
		if (!areRangesEqual) {
			
				NSLog(@"The selected ranges %@ and %@ are not equal. Changing textView.", textView.selectedRangesWithDirections, rangesWithDirections);
			
//				self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
				textView.selectedRangesWithDirections = rangesWithDirections;
//				self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
				
			
		}
		else {
			NSLog(@"Selected ranges %@ and %@ are equal. Ignoring.", textView.selectedRangesWithDirections, rangesWithDirections);
		}
		
	}];
}

- (void)parserDidChangeRange:(NSRange)range toString:(NSString *)string fromString:(NSString *)oldString commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		if (error) {
			NSLog(@"parserDidChangeRange: ERROR: %@", error.localizedDescription);
			return;
		}
		
		NSLog(@"parserDidChangeRange");
		NSTextStorage *textStorage				= self.w.output2.textStorage;
		textStorage.changeFactory.premadeCommit = commit;
		
		NSRange textStorageRange				= NSMakeRange(0, textStorage.length);

		NSInteger changeInLength				= string.length - oldString.length;
		NSRange adjustedRange					= NSMakeRange(range.location, MAX( (NSInteger)range.length - changeInLength, 0 ));

		if (range.location > textStorage.length || ( range.location == textStorage.length && adjustedRange.length != 0 )) {
			NSLog(@"ERROR: Proposed range %@ too far outside textStorage string range %@.",
				  NSStringFromRange(adjustedRange),
				  NSStringFromRange(textStorageRange));
			return;
		}

	//		NSIntersectionRange( NSMakeRange(range.location, newLength), NSMakeRange(0, textStorage.length) );
	//	NSLog(@"the result: %@", NSStringFromRange(adjustedRange));

		BOOL equalRanges = NSEqualRanges(NSIntersectionRange(textStorageRange, range), range);
		NSString *substring = [textStorage.string substringWithRange:adjustedRange];
	//	NSLog(@"comparing %@ to %@", substring, string);
		
		BOOL isTextViewFirstResponder = self.w.firstResponder == self.w.output2;
	//	if (isTextViewFirstResponder) {
	//		NSLog(@"textview is first responder");
	//	}
		if ( ( !equalRanges || ![substring isEqualToString:string] ) && !isTextViewFirstResponder) {
	//			NSLog(@"passed! AMAZIN %@", string);
	//		self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
			[textStorage beginEditing];
			[textStorage replaceCharactersInRange:adjustedRange withString:string];
			[textStorage endEditing];
			self.w.output2.needsDisplay = YES;
	//		self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
		}
	}];
}

//- (BOOL)shouldReplaceTextViewSelectedRangesWith:
//{
//	NSTextView *textView = self.sampleWindow.output2;
//	NSArray *tvSelectedRanges = textView.selectedRangesWithDirections;
//	
//	BOOL areRangesEqual = [selectedRanges isEqualToArrayOfRangesWithDirections:tvSelectedRanges];
//	if (!areRangesEqual && self.parser.status != PPStatusBusy) {
//		textView.selectedRangesWithDirections = selectedRanges;
//	}
//}
//
//- (void)setTextViewSelectedRanges:(NSArray *)selectedRanges
//{
//	NSTextView *textView = self.sampleWindow.output2;
//	NSArray *tvSelectedRanges = textView.selectedRangesWithDirections;
//
//	BOOL areRangesEqual = [selectedRanges isEqualToArrayOfRangesWithDirections:tvSelectedRanges];
//	if (!areRangesEqual && self.parser.status != PPStatusBusy) {
//		
//	}
//}



- (void)parserDidParse:(NSRange)range tokens:(NSArray *)tokens commit:(MGITCommit *)commit parser:(ParseParty *)parser error:(NSError *)error
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		if (error) {
			NSLog(@"parserDidParse: ERROR: %@", error.localizedDescription);
			return;
		}
		
//		self.shouldReportSelectionAndInsertionPointChangesToParser = NO;
		NSTextStorage *textStorage = self.w.output2.textStorage;
		NSLog(@"Great tokens! %@", @(tokens.count));

	//	range = NSIntersectionRange(range, NSMakeRange(0, textStorage.length));
		[self applyTokens:tokens withRangeKey:@"globalRange" toMutableAttributedString:textStorage];
	//	NSAttributedString *string1 = [textStorage attributedSubstringFromRange:range];
	//	
	//	NSMutableAttributedString *string2 = string1.mutableCopy;
	//	[string2 replaceCharactersInRange:NSMakeRange(0, string2.length) withString:string];

	//	[self applyTokens:tokens withRangeKey:@"localRange" toMutableAttributedString:string2];
	//
	//	BOOL isStringTheSame = [string1 isEqualToAttributedString:string2.copy];
	//
	//	if (!isStringTheSame) {
	//		[textStorage beginEditing];
	//		[textStorage replaceCharactersInRange:range withAttributedString:string2];
	//		[textStorage endEditing];
	//	}
	//	else {
	//		NSLog(@"CodeMirror string already matches NSTextView string.");
	//	}
//		self.shouldReportSelectionAndInsertionPointChangesToParser = YES;
	}];
}

//- (BOOL)areTokensTheSame:(NSArray *)tokens toAttributedString:(NSAttributedString *)attributedString
//{
//	NSMutableAttributedString *mutableAttributedString = attributedString.mutableCopy;
//	[self applyTokens:tokens toMutableAttributedString:mutableAttributedString];
//	return [mutableAttributedString.copy isEqualToAttributedString:attributedString];
//}

- (void)applyTokens:(NSArray *)tokens withRangeKey:(NSString *)rangeKey toMutableAttributedString:(NSMutableAttributedString *)mutableAttributedString
{
	for (NSDictionary *token in tokens) {
		NSColor *color = token[@"color"];
		NSRange range = [token[rangeKey] rangeValue];
		
//		NSLog(@"adding token to range %@", NSStringFromRange(range));
		if (color) {
//			[mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
		}
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
