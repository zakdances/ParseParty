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
		
		[ParseParty sharedParser].loadDelegate = self;
		[ParseParty sharedParser].actionDelegate = self;
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
	
	self.sampleWindow.output2.textStorage.delegate = self;
	
	self.sampleWindow.output1.delegate = self;
	self.sampleWindow.output1.dataSource = self;
	
	
	[ParseParty sharedParserWithCodeMirror:self.sampleWindow.input];
//	PPCodeMirrorWindow *cmW = [[ParseParty sharedParser] makeCodeMirrorWindow];
//	
//	NSWindowController *cmWC = [[NSWindowController alloc] initWithWindow:cmW];
//	[self addWindowController:cmWC];
//	cmW.title = @"CodeMirror";
//	[cmWC showWindow:self];
//	
//	
//
	[self.sampleWindow.output2.textStorage.mutableString setString:self.textStorage.string];
	
	
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

	if ([ParseParty sharedParser].codeMirror.status != PPCodeMirrorStatusUnloaded) {

		[self transferTextToParser];
	}


	return YES;
}

- (void)tokenizeInput
{
	[[ParseParty sharedParser] tokenize:self.sampleWindow.output2.textStorage.string tokens:^(NSArray *tokens) {

//		for (NSDictionary *token in tokens) {
//
//
//		}

		self.tokens = tokens;

		[self.sampleWindow.output1 reloadData];

	}];


}

- (void)parseOutput
{
//	[[ParseParty sharedParser] parse:self.sampleWindow.output2.attributedString success:^(NSAttributedString *newAttributedString) {
//		NSLog(@"here you go! %@", newAttributedString);
//	}];

}

//- (void)runAll
//{
//	[self tokenizeInput];
////	[self parseOutput];
//}

- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
	

}

- (void)transferTextToParser
{
	NSLog(@"transferTextToParser");
	[self tokenizeInput];
	[[ParseParty sharedParser] replaceCharactersWith:self.textStorage.string range:NSMakeRange(0, 0) mode:@"scss" parseSubstring:YES response:^(NSDictionary *responseData) {

	}];
}

- (void)parserAction:(NSDictionary *)data
{
	NSAttributedString *attributedString = data[@"attributedString"];
	//	NSLog(@"got it! %@", attributedString.string);
	[attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//		NSLog(@"adding attr: %@", attrs);
//		for (id key in attrs) {
//			if ([attrs[key] isKindOfClass:NSColor.class]) {
//				NSColor *color = attrs[key];
////				NSLog(@"rgb: %@ %@ %@", @(color.redComponent), @(color.greenComponent), @(color.blueComponent));
//			}
//		}
//		NSLog(@"adding attr: %@", self.sampleWindow.output2.textStorage.string);
		[self.sampleWindow.output2.textStorage addAttributes:attrs range:range];
	}];
	
}

- (void)parserLoaded:(ParseParty *)parser
{
	[self transferTextToParser];
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
