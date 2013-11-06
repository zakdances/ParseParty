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
#import <ParseParty/ParseParty+Parse.h>

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
	
	
	[self.sampleWindow.parseButton setAction:@selector(parseButtonAction:)];
	
	
	ParseParty *parser = [ParseParty sharedParserWithCodeMirror:self.sampleWindow.input];
	
	parser.loadDelegate		= self;
	parser.actionDelegate	= self;
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
	[[ParseParty sharedParser] tokenize:string mode:mode tokens:^(NSArray *tokens) {

		self.tokens = tokens;

		[self.sampleWindow.output1 reloadData];

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
	ParseParty *parser = [ParseParty sharedParser];
	[parser parseRange:NSMakeRange(0, parser.codeMirror.docLength) response:^(NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData) {
//		NSLog(@"parsed!");
		[self didParse:range attributedString:attributedString tokens:tokens];
	}];
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
		
		
		NSUInteger docLength = [ParseParty sharedParser].codeMirror.docLength;
//		self.sampleWindow.output2ready = NO;
		NSInteger newLocation			= editedRange.location > docLength ? docLength : editedRange.location;
		NSInteger newLength				= editedRange.length - changeInLength;
		
		// NSRange newRange = NSMakeRange(newLocation, newLength);
		NSRange range = NSIntersectionRange( NSMakeRange(newLocation, newLength), NSMakeRange(0, docLength) );

		
		[[ParseParty sharedParser] replaceCharactersAt:range
										withCharacters:attributedString.string
										thenParseRange:NSMakeRange(editedRange.location, attributedString.length)
											  response:^(NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData)
		{
			NSLog(@"neat! %@", responseData);
			[textStorage beginEditing];
			[textStorage replaceCharactersInRange:range withAttributedString:attributedString];
			[textStorage endEditing];
		}];
	}
	
}



//- (void)transferTextToParser
//{
//	
//	
//}

- (void)parserAction:(NSDictionary *)data
{
	
}

- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens
{
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
	
//	[attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *_attrs, NSRange _range, BOOL *stop) {
//	
//
//		NSMutableDictionary *attrs = _attrs.mutableCopy;
//		attrs[@"range"] = attrs[@"globalRange"];
//		
//		NSDictionary *rangeData = attrs[@"range"];
//		NSRange range = NSMakeRange([rangeData[@"location"] unsignedIntegerValue], [rangeData[@"length"] unsignedIntegerValue]);
//		[textStorage addAttributes:attrs range:range];
//		
//	}];
//
	[textStorage endEditing];

}

- (void)parserLoaded:(ParseParty *)_parser
{
	__weak ParseParty *parser = _parser;
	
	NSLog(@"parserLoaded: %@", parser);
	NSString *mode = @"scss";
	
	[parser setMode:mode response:^(NSString *mode, NSDictionary *responseData) {
		
		

	
		[parser replaceCharactersAt:NSMakeRange(0, 0)
						 withCharacters:self.textStorage.string
						 thenParseRange:NSMakeRange(0, self.textStorage.string.length)
							   response:^(NSRange range, NSAttributedString *attributedString, NSArray *tokens, NSDictionary *responseData)
		{
				
			[self didParse:range attributedString:attributedString tokens:tokens];
			
		}];
	
	}];
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
