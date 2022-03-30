//
//  infoCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/20/22.
//

import UIKit

class infoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTextFieldValue(value: String) {
        textField.text = value
    }
    
}
