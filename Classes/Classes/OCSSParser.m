//
//  OCSSParser.m
//  Objective-CSS-Test
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "OCSSParser.h"
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

- (void)testSCSS:(OCSSBlock)result
{
    NSMutableSet *set = [NSMutableSet set];
    
    NSTreeController *tree = [NSTreeController new];
    tree.selectsInsertedObjects = NO;
    //    TODO: Should child nodes be taken from the model instead of the controller?
    tree.childrenKeyPath = @"blockContent";
//    NSTreeNode *root = [NSTreeNode treeNodeWithRepresentedObject:@{}];
//    tree.content = root;

//    NSDictionary *selector1 = @{ @"type" : @"ruleSet" ,
//                                 @"selector": @".myClass1" ,
//                                 @"block" : @[].mutableCopy};
    OCSSRule *rule1 = [OCSSRule ruleWithSelector:@".myClass1" andBlockContent:nil];
    OCSSRule *rule2 = [OCSSRule ruleWithSelector:@"> header" andBlockContent:nil];
    OCSSRule *rule3 = [OCSSRule ruleWithSelector:@"> .content" andBlockContent:nil];
    OCSSRule *rule4 = [OCSSRule ruleWithSelector:@".myClass2" andBlockContent:nil];

    rule1.blockContent = @[rule2, rule3].mutableCopy;
//    NSDictionary *selector2 = @{ @"type" : @"ruleSet" ,
//                                 @"selector": @"> content" ,
//                                 @"block" : @[
//                                        @{ @"type": @"property" ,
//                                           @"name": @"color" ,
//                                           @"value": @{ @"type": @"color" ,
//                                                        @"string": @"#444444" }}]};
//    
//    NSDictionary *selector3 = @{ @"type" : @"ruleSet" ,
//                                 @"selector": @"> header" ,
//                                 @"block" : @[]};
//    
//    NSDictionary *selector4 = @{ @"type" : @"ruleSet" ,
//                                 @"selector": @".myClass2" ,
//                                 @"block" : @[]};
//    
    [set addObjectsFromArray:@[rule1, rule2, rule3, rule4]];
//    
//    NSTreeNode *selector1node = [NSTreeNode treeNodeWithRepresentedObject:selector1];
//    NSTreeNode *selector2node = [NSTreeNode treeNodeWithRepresentedObject:selector2];
//    NSTreeNode *selector3node = [NSTreeNode treeNodeWithRepresentedObject:selector3];
//    NSTreeNode *selector4node = [NSTreeNode treeNodeWithRepresentedObject:selector4];
    
    
  
//    [selector1 insertValue:!"asd" inPropertyWithKey:@"zzz"];
//    [root addObjectsFromArray:@[selector1, selector3]];
    
//    [root addChild:[NSTreeNode treeNodeWithRepresentedObject:selector1]];
//    
//    [root addChild:[NSTreeNode treeNodeWithRepresentedObject:selector2]];
//    NSMutableOrderedDictionary *selectorValue = [[NSOrderedDictionary orderedDictionaryWithObject:@"._signature" pairedWithKey:@[@"class"]] mutableCopy];
//    [selectorValue addObject:[[NSOrderedDictionary orderedDictionary] mutableCopy] pairedWithKey:@"> content"];
//    [selectorValue addObject:@".myClass1" pairedWithKey:@"name"];
//    [dict addObject:selectorValue pairedWithKey:@"selector"];
//    
//    NSMutableOrderedDictionary *selectorValue2 = [[NSOrderedDictionary orderedDictionaryWithObject:@"._signature" pairedWithKey:@[@"class"]] mutableCopy];
//    [dict addObject:selectorValue2 pairedWithKey:@".myClass2"];

//    [root add:selector1];
//    [root add:selector3];
    

//    [tree insertObject:selector1node atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:0]];
//    [tree insertObject:selector4node atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:1]];
    
    [tree
     insertObjects:@[ rule1, rule4 ]
    atArrangedObjectIndexPaths:@[ [NSIndexPath indexPathWithIndex:0],
                                  [NSIndexPath indexPathWithIndex:1] ]];

    
    tree.selectionIndexPath = [NSIndexPath indexPathWithIndex:0];
    NSTreeNode *node = tree.selectedNodes[0];
//    [tree insertChild:selector2node];
    //    [node.mutableChildNodes addObjectsFromArray:@[selector2node, selector4node]];

//    tree.selectionIndexPaths = @[[NSIndexPath indexPathWithIndex:0], [NSIndexPath indexPathWithIndex:1]];



//    NSLog(@"children: %@", [tree.arrangedObjects childNodes]);
//    
//    
//    NSLog(@"children of first node: %@", [NSNumber numberWithUnsignedInteger:node.childNodes.count]);

    result(set.copy, tree);
}


@end
