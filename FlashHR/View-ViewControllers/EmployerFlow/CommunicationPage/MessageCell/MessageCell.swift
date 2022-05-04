//
//  MessageCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/12/22.
//

import UIKit

class MessageCell: UITableViewCell {

//    @IBOutlet weak var LabelsView: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var colorLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorLabel.layer.cornerRadius = colorLabel.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
