//
//  CalculatorBrain.m
//  Calculator
//
//  Created by smart on 7/20/13.
//  Copyright (c) 2013 smart. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSString *description = @"";
    
    if ([program isKindOfClass:[NSArray class]]) {
        for (id stackElement in program) {
            if ([stackElement isKindOfClass:[NSString class]] || [stackElement isKindOfClass:[NSNumber class]]) {
                description = [description stringByAppendingString:[stackElement description]];
            }
        }
    }
    return description;
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            result = [self popOperandOffStack:stack] / [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            result = - [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack] * -1;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

@end
