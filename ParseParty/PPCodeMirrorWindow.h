//
//  cdCodeMirrorWindow.h
//  Codesaur
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

//#import "cdWindow.h"
#import <Cocoa/Cocoa.h>

@class PPCodeMirror;

@interface PPCodeMirrorWindow : NSWindow

// TODO: weak
@property (weak) PPCodeMirror *codeMirror;

@end
