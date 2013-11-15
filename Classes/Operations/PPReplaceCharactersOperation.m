//
//  PPTokenizeOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPReplaceCharactersOperation.h"
#import "PPParseProtocol.h"

@implementation PPReplaceCharactersOperation

- (void)preflight:(id<PPParseEngine>)engine
{
	self.preflightData = [engine preflightReplaceCharactersAt:_range withCharacters:_characters];
}

- (void)postflight:(id<PPParseEngine>)engine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
	[engine postflightReplaceCharacters:engineResponseData response:^(BOOL success, id responseData) {
		_success = success;
		finished(@{@"success":@(_success)});
	}];
}

@end
