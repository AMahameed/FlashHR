//
//  ViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 2/28/22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = submitButton.frame.size.height / 5
        
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text, !email.isEmpty, !pass.isEmpty {
            
            loginService.performLogin(for: email, password: pass) {
                if UserDataService.shared.isEmployeer {
                    self.presentFromSTB(stbName: "TabBar", vcID: "TabBar")
                }else {
                    self.presentFromSTB(stbName: "EmployeeTabBar", vcID: "EmployeeTabBar")
                
                }
            } failure: { errorString in
                self.presentAlert(message: errorString.description)
            }
        }else{
            presentAlert(message: "Email or Password is not correct!")
        }
    }
 
    @IBAction func forgotPassPressed(_ sender: UIButton) {
        presentFromSTB(stbName: "ResetPassword", vcID: "ResetPassword", presentingStyle: .automatic)
    }
}

