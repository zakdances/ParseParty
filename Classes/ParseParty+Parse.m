//
//  ParseParty+Parse.m
//  Pods
//
//  Created by Zak.
//
//

#import "ParseParty+Parse.h"
#import "PPCodeMirror+Parse.h"
#import <objc/objc-runtime.h>

static void *parseEngineKey;

@implementation ParseParty (Parse)

- (void)getMode:(PPModeResponse)response
{
	if (self.codeMirror) [self.codeMirror getMode:response];
}

- (void)setMode:(NSString *)mode response:(PPModeResponse)response
{
	if (self.codeMirror) [self.codeMirror setMode:mode response:response];
}

- (void)parseRange:(NSRange)range response:(PPParseResponse)response
{
	if (self.parseEngine)
		[self.codeMirror parseRange:range response:response];
	else
		NSLog(@"no parseEngine set");
}

//- (void)didParse:(NSRange)globalRange attributedString:(NSAttributedString *)attributedString tokens:(NSArray *)tokens mode:(NSString *)mode
//{
//	if ([self.parseDelegate respondsToSelector:@selector(didParse:attributedString:tokens:mode:)]) {
//		[self.parseDelegate didParse:globalRange attributedString:attributedString tokens:tokens mode:mode];
//	}
//}

- (id)parseEngine
{
	return objc_getAssociatedObject(self, parseEngineKey);
}

- (void)setParseEngine:(id<PPParseProtocol>)parseEngine
{
	objc_setAssociatedObject(self, parseEngineKey, parseEngine, OBJC_ASSOCIATION_ASSIGN);
}

//- (void)replaceCharacterAt:(NSUInteger)location withCharacter:(NSString *)character triggerEvent:(NSString *)event parseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	// TODO: Make sure it's ONE character.
//	if (self.codeMirror) [self.codeMirror replaceCharacterAt:location withCharacter:character triggerEvent:event parseRange:parseRange response:response];
//}

//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPParseResponse)response
//{
//	if (self.codeMirror) [self.codeMirror replaceCharactersAt:range withCharacters:characters response:response];
//}
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters parseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	if (self.codeMirror) [self.codeMirror replaceCharactersAt:range withCharacters:characters parseRange:parseRange response:response];
//}
//
////- (void)parseEntireDocumentAfterReplacingCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPSetValueResponse)response
////{
////	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:YES parseRange:parseRange response:response];
////}
//
//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseSubstring:(BOOL)parseSubstring response:(PPParseResponse)response
//{
//	// (STUB) TODO: Impliment this.
//}
//
//- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	// (STUB) TODO: Impliment this.
//}

- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPReplaceResponse)response
{
	if (self.parseEngine)
		[self.parseEngine replaceCharactersAt:range withCharacters:characters response:response];
	else
		NSLog(@"no parseEngine set");
}

- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response
{
	if (self.parseEngine)
		[self.parseEngine replaceCharactersAt:range withCharacters:characters thenParseRange:parseRange response:response];
	else
		NSLog(@"no parseEngine set");
}

@end
