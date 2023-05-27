//
//  UserViewController.swift
//  MadeToImpress
//
//  Created by Georgi Manev on 15.01.23.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getSummaryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSummaryBtn.layer.cornerRadius = 5
        self.getSummaryBtn.layer.borderWidth = 1
        self.getSummaryBtn.layer.borderColor = UIColor.link.cgColor
        
        self.usernameTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            currentUser.username = usernameTextField.text ?? ""
            self.firstNameTextField.becomeFirstResponder()
        case firstNameTextField:
            currentUser.firstName = firstNameTextField.text ?? ""
            self.lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            currentUser.lastName = lastNameTextField.text ?? ""
            self.emailTextField.becomeFirstResponder()
        case emailTextField:
            currentUser.email = emailTextField.text ?? ""
            self.emailTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func saveData(_ sender: Any) {
        currentUser.username = usernameTextField.text ?? ""
        currentUser.firstName = firstNameTextField.text ?? ""
        currentUser.lastName = lastNameTextField.text ?? ""
        currentUser.email = emailTextField.text ?? ""
    }
    
}

