//
//  Extensions.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import UIKit

extension UIViewController{
    func presentFromSTB(stbName: String, vcID: String, presentingStyle: UIModalPresentationStyle = .fullScreen) {
        
        let vc = UIStoryboard(name: stbName, bundle: nil).instantiateViewController(withIdentifier: vcID)
        vc.modalPresentationStyle = presentingStyle
        self.present(vc, animated: true, completion: nil)
    }
}


extension UIViewController{
    func presentAlert(title: String = "Error", message: String, preferredStyle: UIAlertController.Style = .actionSheet ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        present(alert, animated: true)
    }
}


extension UIViewController{
    func presentAlertInMainThread(title: String = "Error", message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        DispatchQueue.main.async{
            self.present(alert, animated: true)
            
        }
    }
}

extension Double{
    func roundTo3Decimals(toBeRounded theValue: Double) -> Double {
        
        let roundedValue = (theValue * 1000) / 1000
        return roundedValue
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
