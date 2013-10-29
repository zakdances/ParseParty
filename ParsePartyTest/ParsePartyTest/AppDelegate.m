//
//  PPTAppDelegate.m
//  ParsePartyTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
//       [NSApp setDelegate:self];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
//	NSLog(@"well that's great");
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	NSLog(@"should I?");
//	[[NSWorkspace sharedWorkspace] openFile:@"sample.scss" withApplication:@"self"];

	NSURL *url = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"scss"];
	
	[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
		NSLog(@"nice...");
	}];
	
	return NO;
}

//- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
//{
//	NSLog(@"asdasdasd");
//	return NO;
//}

@end
