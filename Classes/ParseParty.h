//
//  ParseParty.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>

#include "PPProtocols.h"
#include "PPCodeMirror.h"
#include "PPCodeMirrorWindow.h"

#include "PPRule.h"

@interface ParseParty : NSObject <PPTokenize, PPLoadDelegate, PPActionDelegate>

@property (strong) PPCodeMirror *codeMirror;
@property (weak) id <PPLoadDelegate> loadDelegate;
@property (weak) id <PPActionDelegate> actionDelegate;

+ (ParseParty *)sharedParser;
+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror;
- (PPCodeMirrorWindow *)makeCodeMirrorWindow;

@end
