//
//  OCSSParser.m
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "OCSSParser.h"
#import "VerbalExpressions.h"
#import "AKVerbalExpression.h"
#import "PRHVerbalExpression.h"
#import <ParseKit/ParseKit.h>

//static OCSSParser *sharedParser;

@implementation OCSSParser

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        
        // Load my grammer from an external file
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"scss" withExtension:@"grammar"];
        NSError *err = nil;
        
        scssGrammar = [NSString stringWithContentsOfFile:fileURL.path encoding:NSUTF8StringEncoding error:&err];
        
        if (err) {
            NSLog(@"%@", err);
            [[NSAlert alertWithError:err] runModal];
            return;
        }
        
        
        scssParser = [[PKParserFactory factory] parserFromGrammar:scssGrammar assembler:self error:nil];
    }
    return self;
}

+ (OCSSParser *)sharedParser
{
    static OCSSParser *sharedParser;
    
    @synchronized(self)
    {
        if (!sharedParser)
            sharedParser = [self new];
        return sharedParser;
    }
}



- (void)parseTestStringToSCSS
{
    
    NSString *scss = @".myClass { > content {} } "
    ".myClass2 { color: #444444; }";
    
    NSError *err = nil;
    [scssParser parse:scss error:&err];
    if (err) {
        NSLog(@"%@", err);
        [[NSAlert alertWithError:err] runModal];
        return;
    }
    
    
}



- (void)parser:(PKParser *)p didMatchRuleset:(PKAssembly *)a
{
    NSLog(@"ruleset: %@", a.stack);
}

- (void)parser:(PKParser *)p didMatchSelector:(PKAssembly *)a
{
    NSLog(@"selector: %@", a.stack);
}

- (void)parser:(PKParser *)p didMatchProperty:(PKAssembly *)a
{
    //    NSLog(@"properties: %@", a.stack);
}

- (NSOrderedDictionary *)testDict
{
    NSMutableOrderedDictionary *dict = [NSMutableOrderedDictionary orderedDictionary];

    NSMutableOrderedDictionary *selectorValue = [NSMutableOrderedDictionary orderedDictionaryWithObject:@"._signature" pairedWithKey:@[@"class"]];
    [selectorValue addObject:[NSMutableOrderedDictionary orderedDictionary] pairedWithKey:@"> content"];
    [dict addObject:selectorValue pairedWithKey:@".myClass1"];
    
    NSMutableOrderedDictionary *selectorValue2 = [NSMutableOrderedDictionary orderedDictionaryWithObject:@"._signature" pairedWithKey:@[@"class"]];
    [dict addObject:selectorValue2 pairedWithKey:@".myClass2"];
    
    return dict;
}
@end
