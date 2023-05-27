//
//  BookViewController.swift
//  MadeToImpress
//
//  Created by Georgi Manev on 15.01.23.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookContentTextView: UITextView!
    @IBOutlet weak var backgroundSlider: UISlider!
    @IBOutlet weak var showContentSwitch: UISwitch!
    
    var pictureNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTitleLabel.text = books[pictureNumber].title
        bookAuthorLabel.text = books[pictureNumber].author
        bookImageView.image = UIImage(named: books[pictureNumber].picture)
        bookImageView.layer.cornerRadius = 10
        
        bookContentTextView.text = books[pictureNumber].content
        bookContentTextView.setContentOffset(CGPoint.zero, animated: true)
        
        backgroundSlider.value = 0.75
        
        bookImageView.backgroundColor = UIColor(white: CGFloat(backgroundSlider.value), alpha: CGFloat(1.0))
        
        bookContentTextView.alpha = showContentSwitch.isOn ? 1.0 : 0.0
    }

    
    @IBAction func OnPriveousOrNextPressed(_ sender: UIButton) {
        
        switch sender {
        case previousBtn:
            pictureNumber -= 1
            if pictureNumber < 0 {
                pictureNumber = books.count - 1
            }
        case nextBtn:
            pictureNumber += 1
            if pictureNumber >= books.count {
                pictureNumber = 0
            }
        default:
            break
        }
        
        bookTitleLabel.text = books[pictureNumber].title
        bookAuthorLabel.text = books[pictureNumber].author
        bookImageView.image = UIImage(named: books[pictureNumber].picture)
        bookContentTextView.text = books[pictureNumber].content
        bookContentTextView.setContentOffset(CGPoint.zero, animated: true)
        

    }
    
    @IBAction func onSliderValueChange(_ sender: UISlider) {
        bookImageView.backgroundColor = UIColor(white: CGFloat(sender.value), alpha: CGFloat(1.0))
    }
    
    @IBAction func onShowContentSwitch(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.5) {
            self.bookContentTextView.alpha = sender.isOn ? 1.0 : 0.0
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
