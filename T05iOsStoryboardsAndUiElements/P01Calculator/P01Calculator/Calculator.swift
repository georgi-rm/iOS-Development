//
//  Calculator.swift
//  P01Calculator
//
//  Created by Georgi Manev on 4.01.23.
//

import Foundation

enum ArithmeticOperators: String {
    case division = "/"
    case multiplication = "*"
    case addition = "+"
    case subtraction = "-"
    case unknown = ""
}

class Calculator {
    var firstOperand: String = "0"
    var secondOperand: String = "0"
    var result: String = ""
    var operation: ArithmeticOperators = .unknown
    var isCalculationDone:Bool = false
    var isEnteredDecimalPointFirstOperand = false
    var isEnteredDecimalPointSecondOperand = false
    var hasStartedEnteringSecondOperand = false
    
    var isFinishedEnteringFirstOperand: Bool {operation != .unknown}
    
    func clear() {
        self.firstOperand = "0"
        self.secondOperand = "0"
        self.result = ""
        self.operation = .unknown
        self.isCalculationDone = false
        self.isEnteredDecimalPointFirstOperand = false
        self.isEnteredDecimalPointSecondOperand = false
        self.hasStartedEnteringSecondOperand = false
    }
    
    func addDigit(digit: Int) {
        guard digit >= 0,
              digit <= 9 else {
            return
        }
        
        if self.isCalculationDone {
            self.clear()
        }
        
        if !isFinishedEnteringFirstOperand {
            if Double(self.firstOperand) == 0 &&
                self.firstOperand.count <= 1 {
                self.firstOperand = digit.description
            } else {
                self.firstOperand += digit.description
            }
        } else {
            if Double(self.secondOperand) == 0 && self.secondOperand.count <= 1 {
                self.secondOperand = digit.description
            } else {
                self.secondOperand += digit.description
            }
            self.hasStartedEnteringSecondOperand = true
        }
    }
    
    func addDecimalPoint() {
        if self.isCalculationDone {
            self.clear()
        }
        
        if !isFinishedEnteringFirstOperand {
            if !isEnteredDecimalPointFirstOperand {
                if self.firstOperand.count == 0 {
                    self.firstOperand = "0"
                }
                self.firstOperand += "."
                self.isEnteredDecimalPointFirstOperand = true
            }
        } else {
            if !isEnteredDecimalPointSecondOperand {
                if self.secondOperand.count == 0 {
                    self.secondOperand = "0"
                }
                self.secondOperand += "."
                self.hasStartedEnteringSecondOperand = true
                self.isEnteredDecimalPointSecondOperand = true
            }
        }
        
    }
    
    func setOperator(operation: ArithmeticOperators) {
        if hasStartedEnteringSecondOperand {
            return
        }
        
        self.operation = operation
    }
    
    func calculate() {
        let firstOperand: Double = Double(self.firstOperand) ?? 0.0
        let secondOperand: Double = Double(self.secondOperand) ?? 0.0
        var result: Double = 0
        
        if !self.hasStartedEnteringSecondOperand   {
            return
        }
        
        self.isCalculationDone = true
        
        switch self.operation {
        case .division:
            if secondOperand == 0.0 {
                self.result = "Invalid input"
                return
            }
            result = firstOperand / secondOperand
        case.multiplication:
            result = firstOperand * secondOperand
        case.subtraction:
            result = firstOperand - secondOperand
        case.addition:
            result = firstOperand + secondOperand
        default:
            break
        }
        
        self.result = result.description
    }
    
    func stringToShow() -> String {
        var result = self.firstOperand.description
        
        
        if !isFinishedEnteringFirstOperand {
            return result
        }
        
        result += " " + self.operation.rawValue
        
        if !self.hasStartedEnteringSecondOperand {
            return result
        }
        
        result += " " + self.secondOperand.description
        
        if isCalculationDone {
            result += " = " + self.result.description
        }
        
        return result
    }
}
