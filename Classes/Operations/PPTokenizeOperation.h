//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"

@interface PPTokenizeOperation : PPOperation {
	__strong NSString *_stringToTokenize;
}

@property (strong) NSString *prerequestString;
@property (strong) NSString *mode;
@property (strong) NSArray	*tokens;
@property (strong) PPTokenizeResponse responseCallback;

@end
