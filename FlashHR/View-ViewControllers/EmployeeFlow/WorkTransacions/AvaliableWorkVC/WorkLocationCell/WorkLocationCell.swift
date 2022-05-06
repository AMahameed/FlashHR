//
//  WorkLocationCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/5/22.
//

import UIKit
import GoogleMaps

class WorkLocationCell: UITableViewCell{

   
    @IBOutlet weak var locationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationButton.layer.cornerRadius = locationButton.frame.size.height / 5
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        guard let latitude = WorkTranacitonsVC.newWTItem?.lat, let longitude = WorkTranacitonsVC.newWTItem?.long else { return }
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
             UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
         } else {
             UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
         }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
