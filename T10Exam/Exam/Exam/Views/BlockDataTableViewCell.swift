//
//  BlockDataTableViewCell.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import UIKit

class BlockDataTableViewCell: UITableViewCell {
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(with data: BlockDataInLocalDatabase) {
             
        self.heightValueLabel.text = data.blockData?.height.description ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if let time = data.blockData?.eTime {
            self.timeValueLabel.text = dateFormatter.string(from: time)
        }
        
    }
    
}
