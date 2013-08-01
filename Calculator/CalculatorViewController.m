//
//  CalculatorViewController.m
//  Calculator
//
//  Created by smart on 7/20/13.
//  Copyright (c) 2013 smart. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHadPressedDot;
@property (nonatomic, strong) CalculatorBrain *brain;
-(void)clearInput;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize formulaDisplay = _formulaDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHadPressedDot = _userHadPressedDot;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    
    return _brain;
}
- (void)clearInput {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHadPressedDot = NO;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = sender.currentTitle;
    
    //Check if Dot was pressed.
    if ([digit isEqualToString:@"."]) {
        if (self.userHadPressedDot) {
            //Disallow more than 1 dot in number.
            return;
        }
        else {
            self.userHadPressedDot = YES;
        }
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        if (self.userHadPressedDot) {
            self.display.text = @"0.";
        }
        else {
            self.display.text = digit;
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    // adding operation into formula label.
    self.formulaDisplay.text = [self.formulaDisplay.text stringByAppendingString:sender.currentTitle];
    self.formulaDisplay.text = [self.formulaDisplay.text stringByAppendingString:@" "];
    
    // count result.
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // adding = after calulations.
    self.formulaDisplay.text = [self.formulaDisplay.text stringByAppendingString:@"="];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.formulaDisplay.text = [self.formulaDisplay.text stringByAppendingString:self.display.text];
    self.formulaDisplay.text = [self.formulaDisplay.text stringByAppendingString:@" "];
    [self clearInput];
}

- (IBAction)cPressed {
    [self.brain clearStack];
    self.formulaDisplay.text = @"";
    self.display.text = @"0";
    [self clearInput];
}

- (IBAction)backspacePressed {
    if (![self.display.text isEqualToString:@"0"]) {
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        
        if ([self.display.text isEqualToString:@""]) {
            self.display.text = @"0";
            [self clearInput];
        }
    }
}

- (IBAction)removeEqualSign {
    if ([self.formulaDisplay.text length]) {
        NSRange range = [self.formulaDisplay.text rangeOfString:@"="];
        
        if (range.location != NSNotFound) {
            self.formulaDisplay.text = [self.formulaDisplay.text substringToIndex:[self.formulaDisplay.text length] -1];
        }
    }
}

- (IBAction)changeSign {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double number = [self.display.text doubleValue];
        number = number * -1;
        self.display.text = [[NSString alloc] initWithFormat:@"%g", number];
    }
    else {
        // count result.
        double result = [self.brain performOperation:@"+/-"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
}


@end
