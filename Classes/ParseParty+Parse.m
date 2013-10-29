//
//  ParseParty+Parse.m
//  Pods
//
//  Created by Zak.
//
//

#import "ParseParty+Parse.h"
#import "PPCodeMirror+Parse.h"

@implementation ParseParty (Parse)


- (void)parse:(PPParseResponse)response mode:(NSString *)mode
{
	[self.codeMirror parse:response mode:mode];
}

- (void)replaceCharactersWith:(NSString *)substring
						range:(NSRange)range
						 mode:(NSString *)mode
			   parseSubstring:(BOOL)parseSubstring
					 response:(PPSetValueResponse)response
{
	[self.codeMirror replaceCharactersWith:substring range:range mode:mode parseSubstring:parseSubstring response:response];
}

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring
								   mode:(NSString *)mode
						 parseSubstring:(BOOL)parseSubstring
							   response:(PPSetValueResponse)response
{
	
}

- (void)replaceCharactersWith:(NSString *)substring range:(NSRange)range mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response
{
	[self.codeMirror replaceCharactersWith:substring range:range mode:mode parseRange:parseRange response:response];
}

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response
{
	
}

@end
