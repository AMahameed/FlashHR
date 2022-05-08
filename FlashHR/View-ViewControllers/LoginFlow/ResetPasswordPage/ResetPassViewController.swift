//
//  ResetPassViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/1/22.
//

import UIKit

class ResetPassViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 5
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlert(message: "Email field is empty")
            return
        }
      
        loginService.performForgetPassword(email) {
            self.presentFromSTB(stbName: "Login", vcID: "Login")
        } failure: { error in
            self.presentAlert(message: error)
        }
    }
}
