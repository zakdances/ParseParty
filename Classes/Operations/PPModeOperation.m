//
//  PPModeOperation.m
//  ParseParty
//
//  Created by Zak.
//
//

#import "PPModeOperation.h"
#import "PPParseProtocol.h"

@implementation PPModeOperation

- (void)preflight:(id<PPParseEngine>)engine
{
	self.preflightData = [engine preflightMode:self.prerequestMode];
}

- (void)postflight:(id<PPParseEngine>)engine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
	__weak PPModeOperation *weakSelf = self;

	
	[engine postflightMode:engineResponseData response:^(NSString *mode, NSString *fromMode, id responseData) {
		__strong PPModeOperation *strongSelf = weakSelf;
		
		strongSelf.mode = mode;
		strongSelf.fromMode = fromMode;
		finished(@{@"mode":strongSelf.mode,
				   @"fromMode":strongSelf.fromMode});
	}];
}

@end
