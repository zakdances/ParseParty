//
//  AKVerbalExpression.h
//
//  Copyright (c) 2013 Adrian Kashivskyy
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>


@class AKVerbalExpressionAlternationGroup;


/**
 
 Quantification modes used by quantification methods.
 
 @const AKVerbalExpressionQuantificationModeAsFewTimesAsPossible
     Match a token as few times as possible.
 @const AKVerbalExpressionQuantificationModeAsManyTimesAsPossible
     Match a token as many times as possible.
 
*/
typedef NS_ENUM(NSInteger, AKVerbalExpressionQuantificationMode) {
    AKVerbalExpressionQuantificationModeMatchAsFewTimesAsPossible,
    AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible,
} NS_AVAILABLE(10_6, 4_0);

/**
 
 Regular expression flag options.
 
 @const AKVerbalExpressionCaseInsensitiveMatch
     Perform a case-insensitive match.
     (`i` modifier)
 @const AKVerbalExpressionAllowCommentsAndWhitespace
     Allow free-format comments and ignore whitespaces in the expression.
     (`x` modifier)
 @const AKVerbalExpressionDotMatchesLineSeparators
     Allow `.` to match line separators.
     (`s` modifier)
 @const AKVerbalExpressionAnchorsMatchLines 
     Allow `^` and `$` to match line beginning and line ending, respectively.
     (`m` modifier)
 
*/
typedef NS_OPTIONS(NSInteger, AKVerbalExpressionOptions) {
    AKVerbalExpressionCaseInsensitiveMatch         = 1 << 0,
    AKVerbalExpressionAllowCommentsAndWhitespace   = 1 << 1,
    AKVerbalExpressionDotMatchesLineSeparators     = 1 << 2,
    AKVerbalExpressionAnchorsMatchLines            = 1 << 3,
} NS_AVAILABLE(10_6, 4_0);


/**
 
 This class allows you to easily create regex patterns using verbal methods.

*/
NS_CLASS_AVAILABLE(10_6, 4_0) @interface AKVerbalExpression : NSObject


/// @name Initialization


/**
 
 Use this method to create a `NSRegularExpression` object. You configure the
 verbal expression using the `block`.
 
 @param block
     The block where you initialize your expression's pattern.
 
 @return New NSRegularExpression object with pattern created in `block`
 
*/
+ (NSString *)createRegularExpressionPatternContainingMatchesInBlock:(void (^)(AKVerbalExpression *e))block;


/// @name Anchor Matching


/**
 
 Match the beginning of input string. If you want to match beginning of line
 too, wrap your matches inside a flag block and enable the
 AKVerbalExpressionAnchorsMatchLines option.
 
*/
- (void)matchBeginningOfInputString;

/**
 
 Match the end of input string. If you want to match end of line too, wrap your
 matches inside a flag blockand enable the AKVerbalExpressionAnchorsMatchLines
 option.
 
*/
- (void)matchEndOfInputString;


/// @name String Matching


/**
 
 Match a string that must appear in the expression.
 
 @param string
     String to match.
 
 @throws `NSInternalInconsistencyException` if `string` is nil.
 
*/
- (void)matchObligatoryString:(NSString *)string;

/**
 
 Match a string that might or might not appear in the expression.
 
 @param string
     String to match.
 
 @throws `NSInternalInconsistencyException` if `string` is nil.
 
*/
- (void)matchPossibleString:(NSString *)string;

/**
 
 Match any string, or nothing.
 
*/
- (void)matchAnythingConsistingOfAnyCharacters;

/**
 
 Match any string consisting of given characters, or nothing.
 
 @param allowedCharacters
     String of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedCharacters` is nil.
 
*/
- (void)matchAnythingConsistingOfAnyCharactersInString:(NSString *)allowedCharacters;

/**
 
 Match any string consisting of any except given characters, or nothing.
 
 @param forbiddenCharacters
     String of forbidden characters.
 
 @throws `NSInternalInconsistencyException` if `forbiddenCharacters` is nil.
 
*/
- (void)matchAnythingConsistingOfAnyCharactersExceptCharactersInString:(NSString *)forbiddenCharacters;

/**
 
 Match any string consisting of any characters in given range, or nothing.
 
 @param allowedRangeString
     String containing regex-style range of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedRangeString` is nil.
 
*/
- (void)matchAnythingConsistingOfAnyCharactersInRange:(NSString *)allowedRangeString;

/**
 
 Match any string consisting of any except characters in given range, or
 nothing.
 
 @param forbiddenRangeString
     String containing regex-style range of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `forbiddenRangeString` is nil.
 
*/
- (void)matchAnythingConsistingOfAnyCharactersExceptCharactersInRange:(NSString *)forbiddenRangeString;

/**
 
 Match any string exceprt given string, or nothing.
 
 @param forbiddenString
     Forbidden string.
 
 @throws `NSInternalInconsistencyException` if `firbiddenString` is nil.
 
*/
- (void)matchAnythingConsistingOfAnyCharactersExceptString:(NSString *)forbiddenString;

/**
 
 Match any non-empty string.
 
 */
- (void)matchSomethingConsistingOfAnyCharacters;

/**
 
 Match any non-empty string consisting of given characters.
 
 @param allowedCharacters
     String of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedCharacters` is nil.
 
*/
- (void)matchSomethingConsistingOfAnyCharactersInString:(NSString *)allowedCharacters;

/**
 
 Match any non-empty string consisting of any except given characters.
 
 @param forbiddenCharacters
     String of forbidden characters.
 
 @throws `NSInternalInconsistencyException` if `forbiddenCharacters` is nil.
 
*/
- (void)matchSomethingConsistingOfAnyCharactersExceptCharactersInString:(NSString *)forbiddenCharacters;

/**
 
 Match any non-empty string consisting of any characters in given range.
 
 @param allowedRangeString
     String containing regex-style range of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedRangeString` is nil.
 
*/
- (void)matchSomethingConsistingOfAnyCharactersInRange:(NSString *)allowedRangeString;

/**
 
 Match any non-empty string consisting of any except characters in given range.
 
 @param forbiddenRangeString
     String containing regex-style range of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `forbiddenRangeString` is nil
 
*/
- (void)matchSomethingConsistingOfAnyCharactersExceptCharactersInRange:(NSString *)forbiddenRangeString;

/**
 
 Match any non-empty string exceprt given string.
 
 @param forbiddenString
     Forbidden string.
 
 @throws `NSInternalInconsistencyException` if `firbiddenString` is nil.
 
*/
- (void)matchSomethingConsistingOfAnyCharactersExceptString:(NSString *)forbiddenString;


/// @name Character Matching


/**
 
 Match any character except for line breaks. If you want to match line breaks
 too, wrap your matches inside a flag block and enable the
 `AKVerbalExpressionDotMatchesLineSeparators` option.
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
*/
- (void)matchAnyCharacter;

/**
 
 Match any of characters in a given string. This method matches only 1
 character. Use quantification methods to quantify the match.
 
 @param allowedCharacters
     String of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedCharacters` is nil.
 
*/
- (void)matchAnyCharacterOfCharactersInString:(NSString *)allowedCharacters;

/**
 
 Match any character except any of characters in a given string.
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
 @param forbiddenCharacters
     String of forbidden characters.
 
 @throws `NSInternalInconsistencyException` if `forbiddenCharacters` is nil.
 
*/
- (void)matchAnyCharacterExceptCharactersInString:(NSString *)forbiddenCharacters;

/**
 
 Match any character in a given range.
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
 @param allowedRangeString
     String containing regex-style range of allowed characters.
 
 @throws `NSInternalInconsistencyException` if `allowedRangeString` is nil.
 
*/
- (void)matchAnyCharacterOfCharactersInRange:(NSString *)allowedRangeString;

/**
 
 Match any character except characters in a given range.
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
 @param forbiddenRangeString
     String containing regex-style range of forbidden characters.
 
 @throws `NSInternalInconsistencyException` if `allowedRangeString` is nil.
 
*/
- (void)matchAnyCharacterExceptCharactersInRange:(NSString *)forbiddenRangeString;


/// @name Special Character Matching


/**
 
 Match a line-break (`\n` or `\r\n`) character(s).
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
*/
- (void)matchLineBreakCharacter;

/**
 
 Match a tab (`\t`) character.
 
 @note This method matches only 1 character. Use quantification methods to
 quantify the match.
 
*/
- (void)matchTabCharacter;

/**
 
 Accpet any alphanumeric word.

*/
- (void)matchAlphanumeticWord;


/// @name Quantification


/**
 
 Accept previous match 0 or 1 times.
 
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchZeroOrOneTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;

/**
 
 Accept previous match 0 or more times.
 
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchZeroOrMoreTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;

/**
 
 Accept previous match 1 or more times.
 
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchOneOrMoreTimesWithQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;

/**
 
 Accept previous match exactly `n` times.
 
 @param n
     How many times to accept.
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchExactlyTimes:(NSUInteger)n withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;

/**
 
 Accept previous match at least `n` times.
 
 @param n
     At lease how many times to accept.
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchAtLeastTimes:(NSUInteger)n withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;

/**
 
 Accept previous match between `n` and `m` times.
 
 @param n
     At least how many times to accept.
 @param m
     No more than how many times to accept.
 @param mode
     Quantification mode to be used.
 
*/
- (void)acceptPreviousMatchBetweenTimes:(NSUInteger)n and:(NSUInteger)m withQuantificationMode:(AKVerbalExpressionQuantificationMode)mode;


/// @name Groups


/**
 
 Create a capture group containing matches in a given block.
 
 @param block
     Block in which you add matches to your group.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createCaptureGroupContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a non-capture group containing matches in a given block.
 
 @param block
     Block in which you add matches to your group.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createNonCaptureGroupContainingMatchesInBlock:(void (^)())block;

/**
 
 Create an atomic group containing matches in a given block.
 
 @param block
     Block in which you add matches to your group.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createAtomicMatchGroupContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a positive look-ahead assertion containing matches in a given block.
 
 @param block
     Block in which you add matches to your assertion.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createPositiveLookAheadAssertionContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a negative look-ahead assertion containing matches in a given block.
 
 @param block
     Block in which you add matches to your assertion.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createNegativeLookAheadAssertionContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a positive look-behind assertion containing matches in a given block.
 
 @param block
     Block in which you add matches to your assertion.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createPositiveLookBehindAssertionContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a negative look-behind assertion containing matches in a given block.
 
 @param block
     Block in which you add matches to your assertion.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createNegativeLookBehindAssertionContainingMatchesInBlock:(void (^)())block;

/**
 
 Create a non-capture group with given options containing matches in a given
 block.
 
 @param enabledOptions
     Options to enable in the group.
 @param disabledOptions
     Options to disable in the group.
 @param block
     Block in which you add matches to your group.
 
 @see `AKVerbalExpressionOptions` for a list of supported options.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)createNonCaptureGroupWithEnabledOptions:(AKVerbalExpressionOptions)enabledOptions disabledOptions:(AKVerbalExpressionOptions)disabledOptions containingMatchesInBlock:(void (^)())block;


/// @name Alternation


/**
 
 Create an alternation group with given alternations.
 
 @param block
     Block in which you add your alternations.
 
 @throws `NSInternalInconsistencyException` if `block` or is nil.
 
*/
- (void)createAlternationGroupContainingAlernationsInBlock:(void (^)(AKVerbalExpressionAlternationGroup *g))block;


@end


/**
 
 This class is just a wrapper for creating alternative expressions in an expression.
 
*/
@interface AKVerbalExpressionAlternationGroup : NSObject


/**
 
 Add an alternation containing matches in a given block.
 
 @param block
     Block in which you add matches to your alternation.
 
 @throws `NSInternalInconsistencyException` if `block` is nil.
 
*/
- (void)addAlternationContainingMatchesInBlock:(void (^)(AKVerbalExpression *e))block;


@end


@interface NSString (AKVerbalExpressionMatching)

/**
 
 This method allows you to quickly check if the receiver string
 matches the given regular expression pattern.
 
 @param regexPattern
     Pattern that you want your receiver to match
 
 @return `YES` is receiver matches `regexPattern` or `NO` if it doesn't.
 
*/
- (BOOL)matchesRegularExpressionPattern:(NSString *)regexPattern;

@end
