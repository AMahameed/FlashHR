//
//  Helper Services.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/9/22.
//

import UIKit

class HelperServices {
    
    func partialBoldString(_ attString: String, _ normalString: String) -> NSMutableAttributedString {
        let boldText = attString
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalText = normalString
        let normalString = NSMutableAttributedString(string:normalText)
        normalString.append(attributedString)
        return normalString
    }
}
