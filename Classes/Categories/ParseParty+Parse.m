//
//  ParseParty+Parse.m
//  Pods
//
//  Created by Zak.
//
//

//#import "ParseParty.h"

#import "ParseParty+Parse.h"
#import "PPCodeMirror+Parse.h"

#import "PPModeOperation.h"
#import "PPCursorOperation.h"
#import "PPSelectedRangesOperation.h"
#import "PPParseOperation.h"
#import "PPReplaceCharactersOperation.h"
//#import <objc/objc-runtime.h>

//static void *parseEngineKey;

@implementation ParseParty (Parse)

- (void)mode:(NSString *)mode response:(PPModeResponse)response
{
	PPModeOperation *op = [PPModeOperation operation];
	op.prerequestMode = mode;
	op.responseCallback = response;
	[self addRequest:op];
}

- (void)cursorLocation:(NSNumber *)cursorLocation response:(PPCursorLocationResponse)response
{
	PPCursorLocationOperation *op = [PPCursorLocationOperation operation];
	op.prerequestCursorLocation = cursorLocation;
	op.responseCallback = response;
	[self addRequest:op];
}

- (void)selectedAttributedRanges:(NSArray *)attributedRanges response:(PPSelectedAttributedRangesResponse)response
{
	PPSelectedAttributedRangesOperation *op = [PPSelectedAttributedRangesOperation operation];
	op.prerequestAttributedRanges = attributedRanges;
	op.responseCallback = response;
	[self addRequest:op];
}

- (void)parseRange:(NSRangePlus *)range response:(PPParseResponse)response
{
	PPParseRangeOperation *op = [PPParseRangeOperation operation];
	op.prerequestRange = range;
	op.responseCallback = response;
	[self addRequest:op];
}

- (void)replaceCharactersAt:(NSRangePlus *)range withCharacters:(NSString *)characters response:(PPReplaceCharactersResponse)response
{
	PPReplaceCharactersOperation *op	= [PPReplaceCharactersOperation operation];
	op.prerequestRange					= range;
	op.prerequestCharacters				= characters;
	op.responseCallback					= response;
	[self addRequest:op];
}



//- (void)mode:(PPModeResponse)response
//{
//	if (self.parseEngine) {
//		if (_shouldCollectRequestsForSingleOperation) [_requests addObject:@{NSStringFromSelector(@selector(mode:)): response}];
//		else [self.parseEngine mode:response];
//	}
//	else
//		NSLog(@"No parseEngine set.");
//}
//
//- (void)setMode:(NSString *)mode response:(PPModeResponse)response
//{
//	if (self.parseEngine) {
//		if (_shouldCollectRequestsForSingleOperation) [_requests addObject:@{NSStringFromSelector(@selector(setMode:response:)): response}];
//		else [self.parseEngine setMode:mode response:response];
//	}
//	else
//		NSLog(@"No parseEngine set.");
//}
//
//- (void)cursorLocation:(PPSelectedRangesResponse)response
//{
//	
//}
//
//- (void)setCursorLocation:(NSUInteger)cursorLocation response:(PPSelectedRangesResponse)response
//{
//
//}
//
//- (void)selectedRanges:(PPSelectedRangesResponse)response
//{
//	if (self.parseEngine) {
//		if (_shouldCollectRequestsForSingleOperation) [_requests addObject:@{NSStringFromSelector(@selector(cursorLocationAndSelectionRanges:)): response}];
//		else [self.parseEngine cursorLocationAndSelectionRanges:response];
//	}
//	else
//		NSLog(@"No parseEngine set.");
//}
//
//- (void)setSelectedRanges:(NSArray *)attributedRanges response:(PPSelectedRangesResponse)response
//{
//	if (self.parseEngine) {
//		if (_shouldCollectRequestsForSingleOperation) [_requests addObject:@{NSStringFromSelector(@selector(cursorLocationAndSelectionRanges:)): response}];
//		else [self.parseEngine cursorLocationAndSelectionRanges:response];
//	}
//	else
//		NSLog(@"No parseEngine set.");
//}
//
//- (void)parseRange:(NSRange)range response:(PPParseResponse)response
//{
//	if (self.parseEngine)
//		[self.parseEngine parseRange:range response:response];
//	else
//		NSLog(@"No parseEngine set.");
//}
//
//- (id)parseEngine
//{
//	return objc_getAssociatedObject(self, parseEngineKey);
//}
//
//- (void)setParseEngine:(id<PPParseProtocol>)parseEngine
//{
//	objc_setAssociatedObject(self, parseEngineKey, parseEngine, OBJC_ASSOCIATION_ASSIGN);
//}
//
//
//- (void)replaceCharactersAt:(NSRange)range withCharacters:(NSString *)characters response:(PPReplaceResponse)response
//{
//	if (self.parseEngine)
//		[self.parseEngine replaceCharactersAt:range withCharacters:characters response:response];
//	else
//		NSLog(@"no parseEngine set");
//}


@end
