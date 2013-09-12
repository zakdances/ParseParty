//
//  AKVerbalExpression.m
//
//  Copyright (c) 2013 Adrian Kashivskyy
//
//  Licensed under the MIT License.
//

#import "AKVerbalExpression.h"

static NSString * AKVerbalExpressionFlagSettingsFromOptions(AKVerbalExpressionOptions options) {
    if (options == 0) {
        return nil;
    } else {
        NSMutableString *flagSettings = [[NSMutableString alloc] initWithCapacity:4];
        if (options & AKVerbalExpressionCaseInsensitiveMatch) {
            [flagSettings appendString:@"i"];
        }
        if (options & AKVerbalExpressionAllowCommentsAndWhitespace) {
            [flagSettings appendString:@"x"];
        }
        if (options & AKVerbalExpressionDotMatchesLineSeparators) {
            [flagSettings appendString:@"s"];
        }
        if (options & AKVerbalExpressionAnchorsMatchLines) {
            [flagSettings appendString:@"m"];
        }
        if ([flagSettings isEqualToString:@""]) {
            return nil;
        } else {
            return flagSettings;
        }
    }
}

#pragma mark -

@implementation NSString (AKVerbalExpressionMatching)

- (BOOL)matchesRegularExpressionPattern:(NSString *)regexPattern {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern] evaluateWithObject:self];
}

@end

#pragma mark -

@interface AKVerbalExpression ()

@property (nonatomic, assign, readonly) NSString *regularExpressionPattern;
@property (nonatomic, strong) NSMutableArray *regularExpressionPatternPieces;

- (void)appendRegularExpressionPatternPiece:(NSString *)piece;
- (void)appendRegularExpressionPatternPieceWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end

#pragma mark -

@interface AKVerbalExpressionAlternationGroup ()

@property (nonatomic, weak, readonly) NSString *regularExpressionPattern;
@property (nonatomic, strong) NSMutableArray *alternationPieces;
@property (nonatomic, strong) Class verbalExpressionClass;

- (instancetype)initWithVerbalExpressionClass:(Class)verbalExpressionClass;

@end

#pragma mark -

@implementation AKVerbalExpressionAlternationGroup

- (instancetype)initWithVerbalExpressionClass:(Class)verbalExpressionClass {
    self = [super init];
    if (!self) return nil;
    self.verbalExpressionClass = verbalExpressionClass;
    self.alternationPieces = [[NSMutableArray alloc] init];
    return self;
}

- (void)addAlternationContainingMatchesInBlock:(void (^)(AKVerbalExpression *))block {
    NSParameterAssert(block);
    AKVerbalExpression *expression = [[self.verbalExpressionClass alloc] init];
    block(expression);
    [self.alternationPieces addObject:expression.regularExpressionPattern];
}

- (NSString *)regularExpressionPattern {
    return [self.alternationPieces componentsJoinedByString:@"|"];
}

@end

#pragma mark -

@implementation AKVerbalExpression

#pragma mark Initialization

+ (NSString *)createRegularExpressionPatternContainingMatchesInBlock:(void (^)(AKVerbalExpression *))block {
    NSParameterAssert(block);
    AKVerbalExpression *expression = [[self alloc] init];
    [expression createNonCaptureGroupContainingMatchesInBlock:^{
        block(expression);
    }];
    return expression.regularExpressionPattern;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.regularExpressionPatternPieces = [[NSMutableArray alloc] init];
    return self;
}

#pragma mark Pattern Creation

- (void)appendRegularExpressionPatternPiece:(NSString *)piece {
    [self.regularExpressionPatternPieces addObject:piece];
}

- (void)appendRegularExpressionPatternPieceWithFormat:(NSString *)format, ... {
    va_list argumentList;
    va_start(argumentList, format);
    NSString *formattedPatternPiece = [[NSString alloc] initWithFormat:format arguments:argumentList];
    va_end(argumentList);
    [self.regularExpressionPatternPieces addObject:formattedPatternPiece];
}

- (NSString *)regularExpressionPattern {
    return [self.regularExpressionPatternPieces componentsJoinedByString:@""];
}

#pragma mark Anchor Matching

- (void)matchBeginningOfInputString {
    [self appendRegularExpressionPatternPiece:@"^"];
}

- (void)matchEndOfInputString {
    [self appendRegularExpressionPatternPiece:@"$"];
}

#pragma mark String Matching

- (void)matchObligatoryString:(NSString *)string {
    NSParameterAssert(string);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self appendRegularExpressionPatternPiece:[NSRegularExpression escapedPatternForString:string]];
    }];
}

- (void)matchPossibleString:(NSString *)string {
    NSParameterAssert(string);
    [self matchObligatoryString:string];
    [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
}

- (void)matchAnythingConsistingOfAnyCharacters {
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacter];
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchAnythingConsistingOfAnyCharactersInString:(NSString *)allowedCharacters {
    NSParameterAssert(allowedCharacters);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterOfCharactersInString:allowedCharacters];
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchAnythingConsistingOfAnyCharactersExceptCharactersInString:(NSString *)forbiddenCharacters {
    NSParameterAssert(forbiddenCharacters);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterExceptCharactersInString:forbiddenCharacters];
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchAnythingConsistingOfAnyCharactersInRange:(NSString *)allowedRangeString {
    NSParameterAssert(allowedRangeString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterOfCharactersInRange:allowedRangeString];
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchAnythingConsistingOfAnyCharactersExceptCharactersInRange:(NSString *)forbiddenRangeString {
    NSParameterAssert(forbiddenRangeString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterExceptCharactersInRange:forbiddenRangeString];
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchAnythingConsistingOfAnyCharactersExceptString:(NSString *)forbiddenString {
    NSParameterAssert(forbiddenString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self createNegativeLookAheadAssertionContainingMatchesInBlock:^{
            [self matchObligatoryString:forbiddenString];
        }];
        [self matchAnythingConsistingOfAnyCharacters];
    }];
}

- (void)matchSomethingConsistingOfAnyCharacters {
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacter];
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchSomethingConsistingOfAnyCharactersInString:(NSString *)allowedCharacters {
    NSParameterAssert(allowedCharacters);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterOfCharactersInString:allowedCharacters];
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchSomethingConsistingOfAnyCharactersExceptCharactersInString:(NSString *)forbiddenCharacters {
    NSParameterAssert(forbiddenCharacters);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterExceptCharactersInString:forbiddenCharacters];
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchSomethingConsistingOfAnyCharactersInRange:(NSString *)allowedRangeString {
    NSParameterAssert(allowedRangeString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterOfCharactersInRange:allowedRangeString];
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchSomethingConsistingOfAnyCharactersExceptCharactersInRange:(NSString *)forbiddenRangeString {
    NSParameterAssert(forbiddenRangeString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self matchAnyCharacterExceptCharactersInRange:forbiddenRangeString];
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
    }];
}

- (void)matchSomethingConsistingOfAnyCharactersExceptString:(NSString *)forbiddenString {
    NSParameterAssert(forbiddenString);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self createNegativeLookAheadAssertionContainingMatchesInBlock:^{
            [self matchObligatoryString:forbiddenString];
        }];
        [self matchSomethingConsistingOfAnyCharacters];
    }];
}

#pragma mark Character Matching

- (void)matchAnyCharacter {
    [self appendRegularExpressionPatternPiece:@"."];
}

- (void)matchAnyCharacterOfCharactersInString:(NSString *)allowedCharacters {
    NSParameterAssert(allowedCharacters);
    [self appendRegularExpressionPatternPieceWithFormat:@"[%@]", [NSRegularExpression escapedPatternForString:allowedCharacters]];
}

- (void)matchAnyCharacterExceptCharactersInString:(NSString *)forbiddenCharacters {
    NSParameterAssert(forbiddenCharacters);
    [self appendRegularExpressionPatternPieceWithFormat:@"[^%@]", [NSRegularExpression escapedPatternForString:forbiddenCharacters]];
}

- (void)matchAnyCharacterOfCharactersInRange:(NSString *)allowedRangeString {
    NSParameterAssert(allowedRangeString);
    [self appendRegularExpressionPatternPieceWithFormat:@"[%@]", allowedRangeString];
}

- (void)matchAnyCharacterExceptCharactersInRange:(NSString *)forbiddenRangeString {
    NSParameterAssert(forbiddenRangeString);
    [self appendRegularExpressionPatternPieceWithFormat:@"[^%@]", forbiddenRangeString];
}

#pragma mark Special Character Matching

- (void)matchLineBreakCharacter {
    [self createAlternationGroupContainingAlernationsInBlock:^(AKVerbalExpressionAlternationGroup *group) {
        [group addAlternationContainingMatchesInBlock:^(AKVerbalExpression *e) {
            [e matchObligatoryString:@"\\n"];
        }];
        [group addAlternationContainingMatchesInBlock:^(AKVerbalExpression *e) {
            [e matchObligatoryString:@"\\r"];
            [e matchObligatoryString:@"\\n"];
        }];
    }];
}

- (void)matchTabCharacter {
    [self matchObligatoryString:@"\\t"];
}

- (void)matchAlphanumeticWord {
    [self matchObligatoryString:@"\\w"];
    [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
}

#pragma mark Quantification

- (void)acceptPreviousMatchZeroOrOneTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    [self appendRegularExpressionPatternPiece:@"?"];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

- (void)acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    [self appendRegularExpressionPatternPiece:@"*"];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

- (void)acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    [self appendRegularExpressionPatternPiece:@"+"];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

- (void)acceptPreviousMatchExactlyTimes:(NSUInteger)n withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    [self appendRegularExpressionPatternPieceWithFormat:@"{%ld}", (unsigned long)n];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

- (void)acceptPreviousMatchAtLeastTimes:(NSUInteger)n withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    if (n == 0) {
        [self acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:mode];
        return;
    } else if (n == 1) {
        [self acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:mode];
        return;
    }
    [self appendRegularExpressionPatternPieceWithFormat:@"{%ld,}", (unsigned long)n];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

- (void)acceptPreviousMatchBetweenTimes:(NSUInteger)n and:(NSUInteger)m withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode {
    if (n == 0 && m == 1) {
        [self acceptPreviousMatchZeroOrOneTimesWithQuantificationMode:mode];
        return;
    }
    [self appendRegularExpressionPatternPieceWithFormat:@"{%ld,%ld}", (unsigned long)n, (unsigned long)m];
    if (mode == AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible) {
        [self appendRegularExpressionPatternPiece:@"?"];
    }
}

#pragma mark Groups

- (void)createCaptureGroupContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPieceWithFormat:@"("];
    block();
    [self appendRegularExpressionPatternPieceWithFormat:@")"];
}

- (void)createNonCaptureGroupContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?:"];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createAtomicMatchGroupContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?>"];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createPositiveLookAheadAssertionContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?="];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createNegativeLookAheadAssertionContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?!"];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createPositiveLookBehindAssertionContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?<="];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createNegativeLookBehindAssertionContainingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    [self appendRegularExpressionPatternPiece:@"(?<!"];
    block();
    [self appendRegularExpressionPatternPiece:@")"];
}

- (void)createNonCaptureGroupWithEnabledOptions:(AKVerbalExpressionOptions)enabledOptions disabledOptions:(AKVerbalExpressionOptions)disabledOptions containingMatchesInBlock:(void (^)())block {
    NSParameterAssert(block);
    NSMutableString *flagSettings = [[NSMutableString alloc] initWithCapacity:9];
    NSString *enabledFlagSettings = AKVerbalExpressionFlagSettingsFromOptions(enabledOptions);
    NSString *disabledFlagSettings = AKVerbalExpressionFlagSettingsFromOptions(disabledOptions);
    if (enabledFlagSettings) {
        if (disabledFlagSettings) {
            [flagSettings appendFormat:@"%@-%@", enabledFlagSettings, disabledFlagSettings];
        } else {
            [flagSettings appendString:enabledFlagSettings];
        }
    } else {
        if(disabledFlagSettings) {
            [flagSettings appendFormat:@"-%@", disabledFlagSettings];
        }
    }
    if (![flagSettings isEqualToString:@""]) {
        [self appendRegularExpressionPatternPieceWithFormat:@"(?%@:", flagSettings];
        block();
        [self appendRegularExpressionPatternPiece:@")"];
    } else {
        [self createNonCaptureGroupContainingMatchesInBlock:block];
    }
}

#pragma mark Alternation

- (void)createAlternationGroupContainingAlernationsInBlock:(void (^)(AKVerbalExpressionAlternationGroup *))block {
    NSParameterAssert(block);
    AKVerbalExpressionAlternationGroup *group = [[AKVerbalExpressionAlternationGroup alloc] initWithVerbalExpressionClass:[self class]];
    block(group);
    [self createNonCaptureGroupContainingMatchesInBlock:^{
        [self appendRegularExpressionPatternPiece:group.regularExpressionPattern];
    }];
}

@end
