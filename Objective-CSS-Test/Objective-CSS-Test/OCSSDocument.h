//
//  OCSSDocument.h
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class OCSSParser;

@interface OCSSDocument : NSDocument

@property NSTextStorage *fileContents;
@property NSDictionary *parsedCSS;
@end
