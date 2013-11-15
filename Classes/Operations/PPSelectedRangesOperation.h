//
//  PPTokenizeOperation.h
//  Pods
//
//  Created by Zak.
//
//

#import "PPOperation.h"
#import "PPParseProtocol.h"

@interface PPSelectedAttributedRangesOperation : PPOperation

@property (strong) NSArray *prerequestAttributedRanges;
@property (strong) NSArray *attributedRanges;
@property (strong) PPSelectedAttributedRangesResponse responseCallback;

@end
