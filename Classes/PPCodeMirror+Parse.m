//
//  PPCodeMirror+Parse.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPCodeMirror+Parse.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
//#import <Mantle/Mantle.h>
#import <MantleFoundation/NSAttributedString+MantleFoundation.h>
#import <objc/objc-runtime.h>

//static void *parseDelegateKey2;

@implementation PPCodeMirror (Parse)

//- (void)parse:(NSAttributedString *)attributedString success:(PPParseSuccess)success
//{
//
//	NSMutableDictionary *JSONData = [MTLJSONAdapter JSONDictionaryFromModel:attributedString.model].mutableCopy;
//	JSONData[@"mode"] = @"scss";
//
//	[self.webViewbridge callHandler:@"parse" data:JSONData responseCallback:^(id responseData) {
//
//		NSMutableDictionary *newData = [responseData mutableCopy];
//
//		if (!newData[@"string"]) {
//			
//			NSMutableString *mString	= [NSMutableString string];
//			NSUInteger stringLength		= [newData[@"stringLength"] unsignedIntegerValue];
//			NSLog(@"stringLength: %@", @(stringLength));
//			
//			for (int i = 0; i < stringLength; i++) {
//				[mString appendString:@"1"];
//			};
//			newData[@"string"] = mString.copy;
//		}
//
//		
//		NSError *error;
//		NSAttributedString *string = [NSAttributedString attributedStringFromJSON:newData error:&error];
//		if (error) {
//			NSLog(@"%@", error.localizedDescription);
//		}
//		
//
//		NSLog(@"string: %@", string);
//
//		success(string);
//	}];
//	
//
//}

//- (void)parse:(NSAttributedString *)attributedString
//{
//	
//}
//
//- (void)setValue:(NSString *)string mode:(NSString *)mode parse:(BOOL)parse response:(PPSetValueResponse)response
//{
//	NSMutableDictionary *data = @{ @"string": string }.mutableCopy;
//	if (mode) data[@"mode"] = mode;
//	
//	[self.webViewbridge callHandler:@"tokenize" data:data responseCallback:^(id responseData) {
//		
//		NSDictionary *newData = responseData;
//		response(newData);
//	}];
//}

- (void)getMode:(PPModeResponse)response
{
	[self.webViewbridge callHandler:@"mode" data:@{} responseCallback:^(id responseData) {
		
		NSString *mode = responseData[@"mode"];
		response(mode, (NSDictionary *)responseData);
	}];
}

- (void)setMode:(NSString *)mode response:(PPModeResponse)response
{
	[self.webViewbridge callHandler:@"mode" data:@{@"mode":mode} responseCallback:^(id responseData) {
		NSString *mode = responseData[@"mode"];
		response(mode, (NSDictionary *)responseData);
	}];
}

- (void)parseRange:(NSRange)range response:(PPParseResponse)response
{
	NSMutableDictionary *data = @{@"range": @{@"location": @(range.location),
											  @"length": @(range.length)}}.mutableCopy;
//	if (mode) data[@"mode"] = mode;
//	NSLog(@"got here 1...");
	[self.webViewbridge callHandler:@"parse" data:data responseCallback:^(id responseData) {
		
//		NSLog(@"got here 2...");
		[self processParseData:responseData thenCallBlock:response];
	}];
}

- (void)processParseData:(NSDictionary *)data thenCallBlock:(PPParseResponse)response
{
	
	NSDictionary *parseData = data[@"parseData"];
//	if ([self.parseDelegate respondsToSelector:@selector(didParse:attributedString:tokens:mode:)]) {
//	NSLog(@"Is this to be an empathy test? %@", parseData[@"range"]);
	
	NSRange range = NSMakeRange([parseData[@"range"][@"location"] unsignedIntegerValue], [parseData[@"range"][@"length"] unsignedIntegerValue]);
	NSArray			*tokens					= parseData[@"tokens"];
//	NSString		*mode					= data[@"mode"];
	
	NSDictionary	*attributedStringData	= parseData[@"attributedString"];
	NSError *error;
	NSAttributedString *attributedString = [NSAttributedString attributedStringFromJSON:@{@"attributedString": attributedStringData} error:&error];
	if (error) {
		NSLog(@"%@", error);
	}

	response(range, attributedString, tokens, data);
//	[self.parseDelegate didParse:globalRange attributedString:attributedString tokens:tokens mode:mode];
	
	
//	}
		
//	}
}

//- (id)parseDelegate
//{
//	return objc_getAssociatedObject(self, parseDelegateKey2);
//}
//
//- (void)setParseDelegate:(id<PPParseDelegate>)parseDelegate
//{
//	objc_setAssociatedObject(self, parseDelegateKey2, parseDelegate, OBJC_ASSOCIATION_ASSIGN);
//}


//
//- (void)replaceCharacterAt:(NSUInteger)location withCharacter:(NSString *)character triggerEvent:(NSString *)event parseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	// TODO: Make sure it's ONE character.
//	[self _replace:character attributedSubstring:nil range:NSMakeRange(location, 1) triggerEvent:(NSString *)event parse:YES parseRange:parseRange response:response];
//}
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPParseResponse)response
//{
//	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:NO parseRange:NSMakeRange(1, 1) response:response];
//}
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters parseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:YES parseRange:parseRange response:response];
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
	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:NO parseRange:NSMakeRange(0, 0) response:response];
}

- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response
{
	
	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:YES parseRange:parseRange response:^(NSDictionary *responseData) {
//		NSLog(@"great work %@", responseData);
//		return;
		[self processParseData:responseData thenCallBlock:response];
	}];
}

- (void)_replace:(NSString *)substring attributedSubstring:(NSAttributedString *)attributedSubstring
		   range:(NSRange)range
	triggerEvent:(NSString *)event
		   parse:(BOOL)parse
	  parseRange:(NSRange)parseRange
	   response:(PPReplaceResponse)response
{
	NSMutableDictionary *data;
	
	data = @{ @"string": substring,
		@"range": @{ @"location": @(range.location),
							@"length": @(range.length) },
			}.mutableCopy;
	
	if (event) data[@"event"] = event;
	if (parse) {
		data[@"parseRange"] = @{ @"location": @(range.location),
								 @"length": @(substring.length) };
	}
	
	[self.webViewbridge callHandler:@"replaceCharacters" data:data responseCallback:^(id _responseData) {
		
		NSDictionary *responseData = _responseData;
		if (response) response(responseData);
	}];
}
@end
