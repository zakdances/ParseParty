//
//  PPTokenizeOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPTokenizeOperation.h"
#import "PPProtocols.h"

//#import "ParseParty.h"

@implementation PPTokenizeOperation

- (void)preflight:(id<PPTokenizeEngine>)parseEngine
{
	self.preflightData = [parseEngine preflightTokenize:_stringToTokenize];
}

- (void)postflight:(id<PPTokenizeEngine>)parseEngine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
	__weak PPTokenizeOperation *weakSelf = self;
	[parseEngine postflightTokenize:engineResponseData response:^(NSArray *tokens) {
		__strong PPTokenizeOperation *strongSelf = weakSelf;
		strongSelf.tokens = tokens;
		
		finished(@{@"tokens":tokens});
	}];
}

@end
