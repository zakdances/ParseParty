//
//  PPTokenizeOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPParseOperation.h"
#import "PPParseProtocol.h"
#import <Jantle/Jantle.h>

@implementation PPParseRangeOperation

- (void)preflight:(id<PPParseEngine>)engine
{
	self.preflightData = [engine preflightParseRange:_range];
}

- (void)postflight:(id<PPParseEngine>)engine engineResponseData:(id)engineResponseData thenProcessOn:(NSOperationQueue *)operationQueue finished:(PPOperationProcessedResponse)finished
{
//	__weak PPParseOperation *weakSelf = self;
	[engine postflightParseRange:engineResponseData response:^(NSDictionary *attributedStringData, NSArray *tokens, id responseData) {
//		__strong PPParseOperation *strongSelf = weakSelf;
		
		[operationQueue addOperationWithBlock:^{
			
			NSError *error;
			_attributedString = [NSAttributedString fromJSON:attributedStringData error:&error];
			if (error) NSLog(@"%@", error.localizedDescription);
			
			_tokens = tokens;
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				finished(@{@"attributedString":_attributedString,
						   @"tokens":_tokens});
			}];
		}];
		
	}];
}

@end
