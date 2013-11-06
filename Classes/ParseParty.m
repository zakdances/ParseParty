//
//  ParseParty.m
//  Pods
//
//  Created by Zak.
//
//

#import "ParseParty.h"

@implementation ParseParty

//static PPParser *sharedSingleton;

//+ (void)initialize
//{
//    static BOOL initialized = NO;
//    if(!initialized)
//    {
//        initialized = YES;
//        sharedSingleton = [self new];
//    }
//}

- (id)init
{
    self = [super init];
    if (self) {
		
        
		
    }
    return self;
}

+ (ParseParty *)sharedParser
{
//	static ParseParty *sharedParser;
	
	ParseParty *sharedParser = [self sharedParserWithCodeMirror:nil];
	
	if (!sharedParser.codeMirror) {
		NSLog(@"you should NOT see this...");
		sharedParser.codeMirror = [[PPCodeMirror alloc] initWithFrame:CGRectMake(0, 0, 100, 100) frameName:@"CodeMirror" groupName:@"ParseParty"];
//		sharedParser.codeMirror.loadDelegate = sharedParser;
//		sharedParser.codeMirror.actionDelegate = sharedParser;
	}
	
	return sharedParser;
}

+ (ParseParty *)sharedParserWithCodeMirror:(PPCodeMirror *)codeMirror
{
	static ParseParty *sharedParser;
	
	@synchronized(self)
	{
		if (!sharedParser)
			sharedParser = [ParseParty new];
		
		if (codeMirror) {
			sharedParser.codeMirror = codeMirror;
			codeMirror.loadDelegate = sharedParser;
			codeMirror.actionDelegate = sharedParser;
			
			SEL selector = NSSelectorFromString(@"setParseEngine:");
			if ([sharedParser respondsToSelector:selector]) {
				NSLog(@"setting ParseParty as CodeMirror's parseDelegate...");
				[sharedParser performSelector:selector withObject:codeMirror];
			}
			
		}
		
		return sharedParser;
	}
}

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

- (void)tokenize:(NSString *)string mode:(NSString *)mode tokens:(PPTokensBlock)tokensBlock
{
	[self.codeMirror tokenize:string mode:mode tokens:tokensBlock];
}

- (void)parserLoaded:(ParseParty *)parser
{
//	NSLog(@"parserLoaded: %@", self.loadDelegate);
	if ([self.loadDelegate respondsToSelector:@selector(parserLoaded:)]) {
		
		[self.loadDelegate parserLoaded:self];
	}
}

- (void)parserAction:(NSDictionary *)data
{
	if ([self.actionDelegate respondsToSelector:@selector(parserAction:)]) {
		[self.actionDelegate parserAction:data];
	}
}

@end
