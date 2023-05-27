//
//  HomeViewController.swift
//  MadeToImpress
//
//  Created by Georgi Manev on 16.01.23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.welcomeView.tintColor = UIColor.blue
        
        self.welcomeView.layer.cornerRadius = 15
        self.welcomeView.alpha = 0
        
        self.helpBtn.layer.cornerRadius = 5
        self.helpBtn.layer.borderWidth = 1
        self.helpBtn.layer.borderColor = UIColor.orange.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.welcomeView.alpha = 1
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
