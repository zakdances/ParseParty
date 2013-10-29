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

- (void)parse:(PPParseResponse)response mode:(NSString *)mode
{
	NSMutableDictionary *data = @{}.mutableCopy;
	if (mode) data[@"mode"] = mode;
	
	[self.webViewbridge callHandler:@"parse" data:data responseCallback:^(id responseData) {
		
		NSDictionary *newData = responseData;
		response(newData);
	}];
}

- (void)replaceCharactersWith:(NSString *)substring range:(NSRange)range mode:(NSString *)mode parseSubstring:(BOOL)parseSubstring response:(PPSetValueResponse)response
{
	[self _replace:substring attributedSubstring:nil range:range mode:mode parse:parseSubstring parseRange:NSMakeRange(range.location, substring.length) response:response];
}

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseSubstring:(BOOL)parseSubstring response:(PPSetValueResponse)response
{
	// (STUB) TODO: Impliment this.
}

- (void)replaceCharactersWith:(NSString *)substring range:(NSRange)range mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response
{
	[self _replace:substring attributedSubstring:nil range:range mode:mode parse:YES parseRange:parseRange response:response];
}

- (void)replaceAttributedCharactersWith:(NSAttributedString *)attributedSubstring mode:(NSString *)mode parseRange:(NSRange)parseRange response:(PPSetValueResponse)response
{
	// (STUB) TODO: Impliment this.
}

- (void)_replace:(NSString *)substring attributedSubstring:(NSAttributedString *)attributedSubstring
		   range:(NSRange)range
			mode:(NSString *)mode
		   parse:(BOOL)parse
	  parseRange:(NSRange)parseRange
		response:(PPSetValueResponse)response
{
	NSMutableDictionary *data;
	
	data = @{ @"string": substring,
		@"range": @{ @"location": @(range.location),
							@"length": @(range.length) },
			}.mutableCopy;
	if (mode) data[@"mode"] = mode;
	if (parse) {
		data[@"parseRange"] = @{ @"location": @(range.location),
								 @"length": @(substring.length) };
	}
	
	[self.webViewbridge callHandler:@"replaceCharacters" data:data responseCallback:^(id _responseData) {
		
		NSDictionary *responseData = _responseData;
		response(responseData);
	}];
}
@end
