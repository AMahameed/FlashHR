//
//  EmployeeCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/21/22.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var empImage: UIImageView!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        empImage.layer.cornerRadius = empImage.frame.size.height / 5
        stackView.layer.cornerRadius = stackView.frame.size.height / 5
    }
    
    func setupCell(empName: String, empTitle: String, img: Data, isDeleted: Bool) {
        self.empName.text = empName
        self.empTitle.text = empTitle
        self.empImage.image = UIImage(data: img)
        self.stackView.backgroundColor = isDeleted ? UIColor.systemGray : UIColor(named: "whiteBlue")
        self.isUserInteractionEnabled = isDeleted ? false : true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
