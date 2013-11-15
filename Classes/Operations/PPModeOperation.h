//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "PPParseProtocol.h"
//@class PPModeResponse;

@interface PPModeOperation : PPOperation

@property (strong) NSString *prerequestMode;
@property (strong) NSString *mode;
@property (strong) NSString *fromMode;
@property (strong) PPModeResponse responseCallback;

@end
