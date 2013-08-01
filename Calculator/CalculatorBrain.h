//
//  CalculatorBrain.h
//  Calculator
//
//  Created by smart on 7/20/13.
//  Copyright (c) 2013 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)clearStack;
- (double)performOperation:(NSString *)operation;


@end
