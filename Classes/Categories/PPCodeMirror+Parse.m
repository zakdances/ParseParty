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
#import <Jantle/Jantle.h>
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

//- (void)mode:(PPModeResponse)response
//{
//	[self.webViewbridge callHandler:@"mode" data:@{} responseCallback:^(id responseData) {
//		
//		NSString *mode = responseData[@"mode"];
//		response(mode, (NSDictionary *)responseData);
//	}];
//}
//
//- (void)setMode:(NSString *)mode response:(PPModeResponse)response
//{
//	[self.webViewbridge callHandler:@"mode" data:@{@"mode":mode} responseCallback:^(id responseData) {
//		NSString *mode = responseData[@"mode"];
//		response(mode, (NSDictionary *)responseData);
//	}];
//}

- (NSDictionary *)preflightMode:(NSString *)stringToTokenize
{
	NSMutableDictionary *requestData = @{@"requestName":@"mode"}.mutableCopy;
	if (stringToTokenize) requestData[@"string"] = stringToTokenize;
	return requestData;
}

- (BOOL)postflightMode:(id)responseData response:(PPModeResponse)response
{
	NSDictionary	*data		= [self.class requestDataNamed:@"mode" fromResponseData:responseData];
	NSString		*mode		= data[@"mode"];
	NSString		*fromMode	= data[@"fromMode"];
	response(mode,fromMode,responseData);
	return YES;
}


- (NSDictionary *)preflightCursorLocation:(NSNumber *)location
{
	NSMutableDictionary *requestData = @{@"requestName":@"mode"}.mutableCopy;
	if (location) requestData[@"location"] = location;
	return requestData;
}

- (BOOL)postflightCursorLocation:(id)responseData response:(PPCursorLocationResponse)response
{
	NSDictionary	*data		= [self.class requestDataNamed:@"cursorLocation" fromResponseData:responseData];
	NSNumber		*location		= data[@"location"];
	response(location.unsignedIntegerValue,responseData);
	return YES;
}


- (NSDictionary *)preflightSelectedAttributedRanges:(NSArray *)attributedRanges
{
	NSMutableDictionary *requestData = @{@"requestName":@"selectedAttributedRanges"}.mutableCopy;
	
	if (attributedRanges) {
		
		NSMutableArray *selectedAttributedRangesData = [NSMutableArray array];
		requestData[@"ranges"] = selectedAttributedRangesData;

		for (NSAttributedRange *attributedRange in attributedRanges) {
			[selectedAttributedRangesData addObject:[attributedRange toJSON]];
		}

	}
	
	return requestData;
}

- (BOOL)postflightSelectedAttributedRanges:(id)responseData response:(PPSelectedAttributedRangesResponse)response
{
	NSDictionary	*data		= [self.class requestDataNamed:@"selectedAttributedRanges" fromResponseData:responseData];
	NSMutableArray	*ranges		= [data[@"ranges"] mutableCopy];

	[ranges.copy enumerateObjectsUsingBlock:^(NSDictionary *attributedRangeData, NSUInteger idx, BOOL *stop) {
		NSError *error;
		ranges[idx] = [NSRangePlus fromJSON:attributedRangeData error:&error];
		if (error) NSLog(@"%@", error.localizedDescription);
	}];
	
	response(ranges,responseData);
	return YES;
}


- (NSDictionary *)preflightParseRange:(NSRangePlus *)range
{
	NSMutableDictionary *requestData = @{@"requestName":@"parseRange"}.mutableCopy;
	if (range) requestData[@"range"] = [range toJSON];
	return requestData;
}

- (BOOL)postflightParseRange:(id)responseData response:(PPParseEngineResponse)response
{
	NSDictionary	*data					= [self.class requestDataNamed:@"parseRange" fromResponseData:responseData];
	NSDictionary	*attributedStringData	= data[@"attributedString"];
	NSArray			*tokens					= data[@"tokens"];
	response(attributedStringData,tokens,responseData);
	return YES;
}


- (NSDictionary *)preflightReplaceCharactersAt:(NSRangePlus *)range withCharacters:(NSString *)characters
{
	NSMutableDictionary *requestData = @{@"requestName":@"replaceCharacters"}.mutableCopy;
	if (range && characters) {
		requestData[@"range"]		= [range toJSON];
		requestData[@"characters"]	= characters;
	}
	return requestData;
}

- (BOOL)postflightReplaceCharacters:(id)responseData response:(PPReplaceCharactersResponse)response
{
	NSDictionary	*data					= [self.class requestDataNamed:@"replaceCharacters" fromResponseData:responseData];
	BOOL	success	= [data[@"success"] boolValue];
	response(success,responseData);
	return YES;
}



//- (void)cursorLocationAndSelectionRanges:(PPSelectedAttributedRangesResponse)response
//{
//	[self setCursorLocation:NSNotFound setSelectionRanges:nil withAffinities:nil response:response];
//}
//
//- (void)setCursorLocation:(NSUInteger)cursorLocation setSelectionRanges:(NSArray *)selectionRanges withAffinities:(NSArray *)affinities response:(PPSelectionResponse)response
//{
//	
//
//	if ((selectionRanges && affinities && selectionRanges.count != affinities.count) || !(!selectionRanges && !affinities)) {
//		@throw [NSException exceptionWithName:@"Value error" reason:@"[selectionRanges count] must equal [affinities count]" userInfo:nil];
//	}
//	
//	NSMutableArray *mutableSelectionRanges = [NSMutableArray array];
//	[selectionRanges enumerateObjectsUsingBlock:^(NSValue *rangeValue, NSUInteger idx, BOOL *stop) {
//		
//		NSRange range = [rangeValue rangeValue];
//		NSSelectionAffinity affinity = [affinities[idx] unsignedIntegerValue];
//		
//		[mutableSelectionRanges addObject:@{@"location"	:	@(range.location),
//											@"length"	:	@(range.length),
//											@"attributes":
//												@{@"affinity"  :  affinity == NSSelectionAffinityUpstream ? @"up" : @"down"}}
//											];
//	}];
//
//	
////	for (NSNumber *affinity in affinities) {
////		[mutableAffinities addObject:@""];
////	}
//	NSMutableDictionary *data = [NSMutableDictionary dictionary];
//	
//	if (cursorLocation != NSNotFound) {
//		data[@"cursor"] = @{@"location": @(cursorLocation)};
//	}
//	if (selectionRanges && affinities) {
//		data[@"selectionRanges"] = @{@"ranges": mutableSelectionRanges};
//	}
//	
//	
//	
//	[self.webViewbridge callHandler:@"selectionRanges" data:data responseCallback:^(NSDictionary *responseData) {
//
//		
//		NSMutableDictionary *data	= responseData.mutableCopy;
//		
//		NSUInteger cursorLocation = [data[@"cursor"][@"location"] unsignedIntegerValue];
////		NSMutableDictionary *selectedRangesData = [data[@"selectedRangesData"] mutableCopy];
////		data[@"selectedRangesData"] = selectedRangesData;
//		
//		NSMutableArray *selectionRanges	= [data[@"selectionRanges"] mutableCopy];
//		data[@"selectionRanges"] = selectionRanges;
//		
//		NSMutableArray *affinities = [NSMutableArray array];
//		
//		[selectionRanges.copy enumerateObjectsUsingBlock:^(NSDictionary *attributedRange, NSUInteger idx, BOOL *stop) {
//			
//			NSSelectionAffinity affinity = [attributedRange[@"attributes"][@"affinity"] isEqualToString:@"down"] ? NSSelectionAffinityDownstream : NSSelectionAffinityUpstream;
//			[affinities addObject:@(affinity)];
//			
//			NSRange range = NSMakeRange([attributedRange[@"location"] unsignedIntegerValue], [attributedRange[@"length"] unsignedIntegerValue]);
//			selectionRanges[idx] = [NSValue valueWithRange:range];
//			
//			
//		}];
//		
//		
////		NSArray *selections = data[@"selectionData"][@"selections"];
//		response(cursorLocation, selectionRanges, affinities, data);
//	}];
//}
//
//- (void)parseRange:(NSRange)range response:(PPParseResponse)response
//{
//	NSMutableDictionary *data = @{@"range": @{@"location": @(range.location),
//											  @"length": @(range.length)}}.mutableCopy;
////	if (mode) data[@"mode"] = mode;
////	NSLog(@"got here 1...");
//	[self.webViewbridge callHandler:@"parse" data:data responseCallback:^(id responseData) {
//		
////		NSLog(@"got here 2...");
//		[self processParseData:responseData thenCallBlock:response];
//	}];
//}
//
//- (void)processParseData:(NSDictionary *)data thenCallBlock:(PPParseResponse)response
//{
//	NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//		
//
//		NSDictionary *parseData				= data[@"parseData"];
//		NSDictionary *selectedRangesData	= parseData[@"selectedRangesData"];
//		NSDictionary *cursorData			= parseData[@"cursorData"];
//
//		
//		NSDictionary	*rangeData				= parseData[@"range"];
//		NSRange			range					= NSMakeRange([rangeData[@"location"] unsignedIntegerValue], [rangeData[@"length"] unsignedIntegerValue]);
//		NSArray			*tokens					= parseData[@"tokens"];
//		NSDictionary	*attributedStringData	= parseData[@"attributedString"];
//		NSUInteger		cursorLocation			= [cursorData[@"location"] unsignedIntegerValue];
//		
//		NSMutableArray *selectedRanges = [selectedRangesData[@"selectedRanges"] mutableCopy];
//		[selectedRanges.copy enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//			NSRange range = NSMakeRange([obj[@"location"] unsignedIntegerValue], [obj[@"length"] unsignedIntegerValue]);
//			selectedRanges[idx] = [NSValue valueWithRange:range];
//		}];
//		
//		NSSelectionAffinity affinity = [selectedRangesData[@"affinity"] isEqualToString:@"up"] ? NSSelectionAffinityUpstream : NSSelectionAffinityDownstream;
//		
//		NSError *error;
//		NSAttributedString *attributedString = [NSAttributedString attributedStringFromJSON:@{@"attributedString": attributedStringData} error:&error];
//		if (error) {
//			NSLog(@"%@", error);
//		}
//
////	response(range, attributedString, tokens, data);
//
//	}];
//	
//	
//}
//
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPReplaceResponse)response
//{
//	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:NO parseRange:NSMakeRange(0, 0) response:response];
//}
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters thenParseRange:(NSRange)parseRange response:(PPParseResponse)response
//{
//	[self _replace:characters attributedSubstring:nil range:range triggerEvent:nil parse:YES parseRange:parseRange response:^(NSDictionary *responseData) {
//		[self processParseData:responseData thenCallBlock:response];
//	}];
//}
//
//- (void)_replace:(NSString *)substring attributedSubstring:(NSAttributedString *)attributedSubstring
//		   range:(NSRange)range
//	triggerEvent:(NSString *)event
//		   parse:(BOOL)parse
//	  parseRange:(NSRange)parseRange
//	   response:(PPReplaceResponse)response
//{
//	NSMutableDictionary *data;
//	
//	data = @{ @"string": substring,
//			  @"range": @{ @"location": @(range.location),
//						   @"length": @(range.length) },
//			}.mutableCopy;
//	
//	if (event) data[@"event"] = event;
//	if (parse) {
//		data[@"parseRange"] = @{ @"location": @(range.location),
//								 @"length": @(substring.length) };
//	}
//	
//	[self.webViewbridge callHandler:@"replaceCharacters" data:data responseCallback:^(NSDictionary *responseData) {
//		
//		if (response) response(responseData);
//	}];
//}

@end
