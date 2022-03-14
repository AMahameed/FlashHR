//
//  MessageCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/12/22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var labelsView: UIStackView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
}
