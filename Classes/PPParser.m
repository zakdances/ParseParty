//
//  ParseParty.m
//  Pods
//
//  Created by Zak.
//
//

#import "ParseParty.h"
#import "PPRequestOperation.h"

@interface ParseParty ()

@property	PPStatus		status;
// Utility property to get weak reference to self.
// TODO: This should be a method with an easy getter.
//@property (weak) ParseParty *weak;

@end

@implementation ParseParty

- (id)init
{
    self = [super init];
    if (self) {
		
        _postflightProcessingQueue = [NSOperationQueue new];
//		_requestQueue.maxConcurrentOperationCount = 1;
//		[_requests setSuspended:YES];
		_pendingRequests = [NSMutableArray array];
    }
    return self;
}

+ (ParseParty *)parser
{
	PPCodeMirror *codeMirror = [[PPCodeMirror alloc] initWithFrame:CGRectMake(0, 0, 200, 200) frameName:@"CodeMirror" groupName:@"ParseParty"];
	ParseParty *parser = [self parserWithCodeMirror:codeMirror];
	
	return parser;
}

+ (ParseParty *)parserWithCodeMirror:(PPCodeMirror *)codeMirror
{
//	@synchronized(self) {
	ParseParty *parser = [ParseParty new];
		
	parser.codeMirror			= codeMirror;
	parser.engine				= (id)codeMirror;
		
	codeMirror.statusDelegate	= parser;
	
	return parser;
//	}
}

//+ (ParseParty *)sharedParser
//{
////	static ParseParty *sharedParser;
//	
//	ParseParty *sharedParser = [self sharedParserWithCodeMirror:nil];
//	
//	if (!sharedParser.codeMirror) {
//		NSLog(@"you should NOT see this...");
//		sharedParser.codeMirror = [[PPCodeMirror alloc] initWithFrame:CGRectMake(0, 0, 100, 100) frameName:@"CodeMirror" groupName:@"ParseParty"];
////		sharedParser.codeMirror.loadDelegate = sharedParser;
////		sharedParser.codeMirror.actionDelegate = sharedParser;
//	}
//	
//	return sharedParser;
//}

//+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror
//{
//	static ParseParty *sharedParser;
//	
//	@synchronized(self)
//	{
//		if (!sharedParser)
//			sharedParser = [ParseParty new];
//		
//		if (codeMirror) {
//			sharedParser.codeMirror = codeMirror;
//			codeMirror.statusDelegate = sharedParser;
//			
//			SEL selector = NSSelectorFromString(@"setParseEngine:");
//			if ([sharedParser respondsToSelector:selector]) {
//				[sharedParser performSelector:selector withObject:codeMirror];
//			}
//
//		}
//		
//		return sharedParser;
//	}
//}

- (PPCodeMirrorWindow *)makeCodeMirrorWindow
{
	PPCodeMirrorWindow *cmWindow = [[PPCodeMirrorWindow alloc] initWithContentRect:CGRectMake(200, 200, 200, 200) styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	((NSView *)cmWindow.contentView).autoresizesSubviews = YES;
	cmWindow.title = @"CodeMirror";
	cmWindow.codeMirror = self.codeMirror;
	
	self.codeMirror.frame				= [cmWindow.contentView frame];
	self.codeMirror.autoresizingMask	= NSViewWidthSizable | NSViewHeightSizable;
	
	[cmWindow.contentView addSubview:self.codeMirror];
	
	return cmWindow;
}

//- (__weak ParseParty *)weak
//{
//	__weak ParseParty *_self = self;
//	return _self;
//}
//
//- (void)setWeak:(__weak ParseParty *)weak {}

- (void)beginRequest
{
	_shouldCollectMultipleRequests = YES;
//	_compoundRequestData = [NSMutableArray array];
//	__weak ParseParty *_self = self;

	
//	PPRequestOperation *op = [PPRequestOperation blockOperationWithBlock:^(PPOperation *op) {
//		[_self.parseEngine requests:op.dependants.allObjects responses:^(NSArray *responseData) {
//		
//		}];
//	}];
//	[_requests setSuspended:YES];

	

	

}

//- (void)beginSingleRequest
//{
////	_shouldCollectMultipleRequests = NO;
//
//	
//}

- (void)endRequest:(PPCompoundResponse)compoundResponse
{
//	__weak ParseParty *weakSelf = self;
	__weak id weakEngine = self.engine;
	__weak NSOperationQueue *weakPostflightProcessingQueue = _postflightProcessingQueue;
	
	__strong NSArray *pendingRequests = _pendingRequests.copy;
	[_pendingRequests removeAllObjects];
	_shouldCollectMultipleRequests = NO;
//	NSMutableArray *requests = [NSMutableArray array];
	
	
	// Start Operation
//	PPOperation *startOp_strong = [PPOperation new];
//	__weak PPOperation *startOp = startOp_strong;
//	[startOp dependantReferenceStrength:PPOperationDependantReferenceStrong];
//
//	[startOp addExecutionBlock:^{
//		[_self.parseEngine requests:requests responses:^(NSArray *responseData) {
//			
//		}];
//		startOp.requestData[@"upi"] = @"asdasd";
//	}];
//	
//	[startOp setCompletionBlock:^{
//		
//	}];
	NSMutableArray *requestData = [NSMutableArray array];
	
	for (PPOperation *op in pendingRequests) {
		[op preflight:self.engine];
		[requestData addObject:op.preflightData];
	}
	
	[self.engine request:requestData response:^(id responseData) {
		
//		__strong ParseParty *strongSelf								= weakSelf;
		__strong id strongEngine									= weakEngine;
		__strong NSOperationQueue *strongPostflightProcessingQueue	= weakPostflightProcessingQueue;
		
		NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
		
		
		NSMutableArray *compoundData = [NSMutableArray array];
		[pendingRequests enumerateObjectsUsingBlock:^(PPOperation *op, NSUInteger idx, BOOL *stop) {
			
			NSMutableDictionary *processedData = [NSMutableDictionary dictionary];
			[compoundData addObject:processedData];
			
			[op postflight:strongEngine engineResponseData:responseData thenProcessOn:strongPostflightProcessingQueue finished:^(NSDictionary *_processedData) {
				
				[processedData addEntriesFromDictionary:_processedData];
				
				[mainQueue addOperationWithBlock:^{
					[op callCallback];
					if (compoundResponse && idx == pendingRequests.count - 1) {
						compoundResponse(compoundData);
					}
				}];
		
			}];
		}];
//		for (PPOperation *op in pendingRequests) {
//			
//		}
		
	}];
	

	
}

- (void)addRequest:(PPOperation *)request
{

	[_pendingRequests addObject:request];
		
	if (!_shouldCollectMultipleRequests) {
		[self endRequest:nil];
	}
	
//	Deferred *d = [Deferred deferred];
//
//	[d on:_requests run:^(Deferred *d) {
//		[d resolve:request];
////		[_self.parseEngine requests:op.dependants.allObjects responses:^(NSArray *responseData) {
////			
////		}];
//	}];
	
	
}


- (void)tokenize:(NSString *)string mode:(NSString *)mode response:(PPTokenizeResponse)response
{
	PPTokenizeOperation *op = [PPTokenizeOperation operation];
	op.prerequestString = string;
	op.mode = mode;
	op.responseCallback = response;
	[self addRequest:op];
}




- (void)parserStatusDidChangeTo:(PPStatus)newStatus from:(PPStatus)oldStatus parser:(ParseParty *)parser
{
	if (newStatus != oldStatus) {
		self.status = newStatus;

		if ([self.statusDelegate respondsToSelector:@selector(parserStatusDidChangeTo:from:parser:)]) {
			[self.statusDelegate parserStatusDidChangeTo:newStatus from:oldStatus parser:self];
		}
	}
}

- (void)parserDocDidChange:(NSDictionary *)responseData parser:(ParseParty *)parser
{
	if ([self.statusDelegate respondsToSelector:@selector(parserDocDidChange:parser:)]) {
		[self.statusDelegate parserDocDidChange:responseData parser:self];
	}
}

@end
