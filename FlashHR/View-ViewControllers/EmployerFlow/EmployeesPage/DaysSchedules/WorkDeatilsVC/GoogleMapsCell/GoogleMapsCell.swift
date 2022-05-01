//
//  GoogleMapsCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/30/22.
//

import UIKit
import CoreLocation

protocol GoogleMapsCellDelegate {
    func buttonDidClicked()
}

class GoogleMapsCell: UITableViewCell {
    
    @IBOutlet weak var locationButton: UIButton!
    var delegate: GoogleMapsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationButton.layer.cornerRadius = locationButton.frame.size.height / 5
    }

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.buttonDidClicked()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
