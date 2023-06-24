//
//  AddAccountViewController.swift
//  Exam
//
//  Created by Georgi Manev on 4.02.23.
//

import UIKit

class AddAccountViewController: UIViewController {
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountNameTextField.delegate = self
        errorLabel.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountNameTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        LocalDataManager.accounts = accountNameTextField.text ?? ""
    }

    @IBAction func onPressConfirm(_ sender: Any) {
        
        RequestManager.fetchCheckAccount(accountAddress: accountNameTextField.text ?? "") { error, result in
            guard error == nil else {
                print("Error in fetching data")
                return
            }

            guard let accountData = result else {
                print("Can not parse data")
                return
            }

            if let accountError = accountData.error {
                self.errorLabel.text = accountError
            } else {
                self.errorLabel.text = ""
                
                if let countOfTransactions = accountData.txs,
                   let accountName = self.accountNameTextField.text,
                   countOfTransactions > 0{
                    LocalDataManager.accounts.append(accountName)
                }
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.accountNameTextField:
            self.accountNameTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
