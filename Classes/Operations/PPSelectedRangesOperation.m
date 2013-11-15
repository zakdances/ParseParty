//
//  PPTokenizeOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPSelectedRangesOperation.h"
#import "PPParseProtocol.h"
#import <Jantle/Jantle.h>

@implementation PPSelectedAttributedRangesOperation

- (void)preflight:(id<PPParseEngine>)engine
{
	self.preflightData = [engine preflightSelectedAttributedRanges:self.prerequestRanges];
}

- (void)postflight:(id<PPParseEngine>)engine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
	[engine postflightSelectedAttributedRanges:engineResponseData response:^(NSArray *selectedAttributedRanges, id responseData) {
		self.ranges = selectedAttributedRanges;
		finished(@{@"ranges":self.ranges});
	}];
}

@end
