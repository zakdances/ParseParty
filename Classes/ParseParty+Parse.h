//
//  ParseParty+Parse.h
//  Pods
//
//  Created by Zak.
//
//

#import "ParseParty.h"
#import "PPParseProtocol.h"

@interface ParseParty (Parse) <PPParseProtocol>

@property (weak) id <PPParseProtocol> parseEngine;

@end
