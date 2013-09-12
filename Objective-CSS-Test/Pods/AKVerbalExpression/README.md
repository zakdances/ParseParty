# AKVerbalExpression

AKVerbalExpression is a class that allows you to quickly create simple or complicated regular expressions using very intuitive and verbal methods.

### Inspiration

This project was inspired by [VerbalExpressions/PHPVerbalExpressions](https://github.com/VerbalExpressions/PHPVerbalExpressions) repository, but I didn't want to create a repository there, because my class is way more powerful and API-incompatible with theirs.

### Requirements

AKVerbalExpression requires Grand Central Dispatch which is available since **OS X 10.6 and iOS 4.0**.

### To-do

- More test specs
- More examples
- Full documentation

## Installation

#### Git Submodule

If you're using a git repository for your project, you can simply add AKVerbalExpression as a submodule using `git submodule` command:

```sh
$ git submodule add https://github.com/akashivskyy/AKVerbalExpression.git <path>
```

#### CocoaPods

If you're using [CocoaPods](http://cocoapods.org), add this to your `Podfile`:

```ruby
pod 'AKVerbalExpression'
```

#### Source Files

If you don't want to bother with git or CocoaPods, simply drag files from the `AKVerbalExpression` folder to your project. No dependencies or other setup is required.

## Basic Usage

#### Example #1: Check if hostname is correct

```objc 
NSString *hostnameRegexPattern = [AKVerbalExpression createRegularExpressionPatternContainingMatchesInBlock:^(AKVerbalExpression *e) {
    [e createCaptureGroupContainingMatchesInBlock:^{
        [e matchBeginningOfInputString];
        [e matchObligatoryString:@"http"];
        [e matchPossibleString:@"s"];
        [e matchObligatoryString:@"://"];
        [e matchPossibleString:@"www."];
        [e matchSomethingConsistingOfAnyCharactersInString:@" "];
        [e matchEndOfInputString];
    }];
}];

BOOL matches = [@"https://www.example.net/path/to/file.php?var=value&second=value#anchor" matchesRegularExpressionPattern:hostnameRegexPattern];
```

#### Example #2: Check if email address is correct

```objc
NSString *emailRegexPattern = [AKVerbalExpression createRegularExpressionPatternContainingMatchesInBlock:^(AKVerbalExpression *e) {
    [e createCaptureGroupContainingMatchesInBlock:^{
        [e matchBeginningOfInputString];
        [e matchSomethingConsistingOfAnyCharactersInRange:@"A-Za-z0-9._%+-"];
        [e matchObligatoryString:@"@"];
        [e matchSomethingConsistingOfAnyCharactersInRange:@"A-Za-z0-9.-"];
        [e matchObligatoryString:@"."];
        [e matchAnyCharacterOfCharactersInRange:@"A-Za-z"];
        [e acceptPreviousMatchBetweenTimes:1 and:4 withQuantificationMode:AKVerbalExpressionQuantificationModeMatchAsManyTimesAsPossible];
        [e matchEndOfInputString];
    }];
}];

BOOL matches = [@"my.fancy_email+no-reply@address.com" matchesRegularExpressionPattern:emailRegexPattern];
```

## Documentation

Full documentation can be found in the **[wiki](https://github.com/akashivskyy/AKVerbalExpression/wiki)**, but it is currently under construction, so you might refer to the **[fully-documented header file](AKVerbalExpression/AKVerbalExpression.h)**.

### More Examples

If you would like to look through more examples, be sure to check out the **[unit test specs](AKVerbalExpression Tests/)** included in this repository. Every test does something different and you can learn the syntax from there.

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE.md).