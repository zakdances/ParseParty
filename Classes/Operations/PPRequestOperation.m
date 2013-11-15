//
//  PPTokenizeOperation.m
//  Pods
//
//  Created by Zak.
//
//

#import "PPRequestOperation.h"

@implementation PPRequestOperation

- (id)init
{
    self = [super init];
    if (self) {
//        self.dependantReferenceStrength = PPOperationDependantReferenceStrong;
    }
    return self;
}
//- (void)start
//{
//	if (![NSThread isMainThread]) {
//		[self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
//		return;
//	}
//	
//	[self willChangeValueForKey:@"isExecuting"];
//	
//	_isExecuting = YES;
//	
//	[self didChangeValueForKey:@"isExecuting"];
//	
//	for (PPBlock block in self.executionBlocks) {
//		block(self);
//	}
//}
//
//- (void)finish
//{
//	[self willChangeValueForKey:@"isExecuting"];
//	[self willChangeValueForKey:@"isFinished"];
//	
//	_isExecuting = NO;
//	_isFinished = YES;
//	
//	[self didChangeValueForKey:@"isExecuting"];
//	[self didChangeValueForKey:@"isFinished"];
//}

@end
