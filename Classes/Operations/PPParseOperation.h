//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
@class NSRangePlus;

@interface PPParseRangeOperation : PPOperation {
	__strong NSRangePlus *_range;
	__strong NSAttributedString *_attributedString;
	__strong NSArray *_tokens;
}

@property (strong) NSRangePlus *prerequestRange;
@property (strong) PPParseResponse responseCallback;

@end
