//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "PPParseProtocol.h"

@interface PPCursorLocationOperation : PPOperation

@property NSNumber *prerequestCursorLocation;
@property (strong) PPCursorLocationResponse responseCallback;

@end
