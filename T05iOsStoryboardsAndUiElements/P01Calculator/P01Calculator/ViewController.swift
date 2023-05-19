//
//  ViewController.swift
//  P01Calculator
//
//  Created by Georgi Manev on 3.01.23.
//

import UIKit





class ViewController: UIViewController {

    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var treeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var divideBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var equalBtn: UIButton!
    @IBOutlet weak var decimalPointBtn: UIButton!
    @IBOutlet weak var resultTextField: UITextField!
    
    var calculator: Calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allButtons = [clearBtn, oneBtn, twoBtn, treeBtn, fourBtn, fiveBtn, sixBtn, sevenBtn, eightBtn, nineBtn, zeroBtn, divideBtn, multiplyBtn, minusBtn, plusBtn, equalBtn, decimalPointBtn]
        
        for aButton in allButtons {
            aButton?.layer.cornerRadius = 5
            aButton?.layer.borderWidth = 1
            aButton?.layer.borderColor = UIColor.link.cgColor
        }
        
        resultTextField.layer.borderWidth = 1
        resultTextField.layer.borderColor = UIColor.link.cgColor

        self.resultTextField.text = "0"
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        calculator.clear()
        self.resultTextField.text = calculator.stringToShow()
    }
    
    @IBAction func onDigitPress(_ sender: UIButton) {
        var digit: Int
        switch sender {
        case oneBtn:
            digit = 1
        case twoBtn:
            digit = 2
        case treeBtn:
            digit = 3
        case fourBtn:
            digit = 4
        case fiveBtn:
            digit = 5
        case sixBtn:
            digit = 6
        case sevenBtn:
            digit = 7
        case eightBtn:
            digit = 8
        case nineBtn:
            digit = 9
        case zeroBtn:
            digit = 0
        default:
            return
        }
        
        calculator.addDigit(digit: digit)
        self.resultTextField.text = calculator.stringToShow()
    }
    
    @IBAction func onOperatorButtonPressed(_ sender: UIButton) {
        
        var operatorType: ArithmeticOperators
        
        switch sender {
        case divideBtn:
            operatorType = .division
        case multiplyBtn:
            operatorType = .multiplication
        case minusBtn:
            operatorType = .subtraction
        case plusBtn:
            operatorType = .addition
        default:
            return
        }
        
        calculator.setOperator(operation: operatorType)
        
        self.resultTextField.text = calculator.stringToShow()
    }
    
    @IBAction func onDecimalPointButtonPressed(_ sender: Any) {
        calculator.addDecimalPoint()
        self.resultTextField.text = calculator.stringToShow()
    }
    
    @IBAction func onCalculateButtonPressed(_ sender: Any) {
        calculator.calculate()
        self.resultTextField.text = calculator.stringToShow()
    }
    
    
}
