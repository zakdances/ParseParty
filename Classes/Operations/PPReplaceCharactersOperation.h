//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "PPParseProtocol.h"
@class NSRangePlus;

@interface PPReplaceCharactersOperation : PPOperation {
	__strong NSRangePlus *_range;
	__strong NSString *_characters;
	BOOL _success;
}

@property (strong) NSRangePlus *prerequestRange;
@property (strong) NSString *prerequestCharacters;
@property (strong) PPReplaceCharactersResponse responseCallback;

@end
