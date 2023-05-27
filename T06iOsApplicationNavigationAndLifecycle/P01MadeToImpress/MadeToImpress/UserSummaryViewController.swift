//
//  UserSummaryViewController.swift
//  MadeToImpress
//
//  Created by Georgi Manev on 17.01.23.
//

import UIKit

class UserSummaryViewController: UIViewController {
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var firstNameValueLabel: UILabel!
    @IBOutlet weak var lastNameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.greenView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usernameValueLabel.text = currentUser.username
        self.firstNameValueLabel.text = currentUser.firstName
        self.lastNameValueLabel.text = currentUser.lastName
        self.emailValueLabel.text = currentUser.email
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
