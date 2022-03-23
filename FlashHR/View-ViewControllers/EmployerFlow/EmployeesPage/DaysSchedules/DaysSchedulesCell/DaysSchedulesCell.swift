//
//  DaysSchedulesCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit

class DaysSchedulesCell: UITableViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayView.layer.cornerRadius = dayView.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
