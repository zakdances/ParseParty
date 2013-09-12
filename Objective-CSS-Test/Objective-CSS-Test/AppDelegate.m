//
//  AppDelegate.m
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

-(BOOL)applicationShouldOpenUntitledFile:(NSApplication*)app
{
    NSLog(@"should I?");
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"scss"];
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:fileURL display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
        NSLog(@"done!");
    }];
    return NO; //<<<<< That's the trick
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
//    NSURL *fileURL = [NSURL fileURLWithPath:[@"./sample.scss" stringByExpandingTildeInPath] isDirectory:NO];
//    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:fileURL display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
//        NSLog(@"done!");
//        if (error) {
//            NSLog(@"%@", error);
//        }
//    }];
}

@end
