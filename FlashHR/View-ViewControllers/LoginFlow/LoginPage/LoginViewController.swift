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

        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text, !email.isEmpty, !pass.isEmpty {
            loginService.performLogin(for: email, password: pass) {
                if UserDataService.shared.isEmployeer{
                  print("Employeers logged")
                }else {
                    
                }
            } failure: { errorString in
                print(errorString)
            }
        }
    }
 
    @IBAction func forgotPassPressed(_ sender: UIButton) {
        presentFromSTB(stbName: "ResetPassword", vcID: "ResetPassword", presentingStyle: .automatic)
    }
}

