//
//  RequestCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/11/22.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        acceptButton.layer.cornerRadius = acceptButton.frame.size.height / 5
        rejectButton.layer.cornerRadius = rejectButton.frame.size.height / 5
        userImage.layer.cornerRadius = userImage.frame.size.height / 5
        stackView.layer.cornerRadius = stackView.frame.size.height / 5
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptPressed(_ sender: UIButton) {
        print("Hello World")
    }
    
    @IBAction func rejectPressed(_ sender: UIButton) {
        print("Hello World")
    }
}
