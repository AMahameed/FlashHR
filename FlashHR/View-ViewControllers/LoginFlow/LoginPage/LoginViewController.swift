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
                    self.loginAsEmployeeOrHR { trueIfHR in
                        if trueIfHR{
                            self.presentFromSTB(stbName: "TabBar", vcID: "TabBar")
                        }else{
                            self.presentFromSTB(stbName: "EmployeeTabBar", vcID: "EmployeeTabBar")
                        }
                    }
                }else {
                    self.presentFromSTB(stbName: "EmployeeTabBar", vcID: "EmployeeTabBar")
                
                }
            } failure: { error in
                self.presentAlert(message: error)
            }
        }else{
            presentAlert(message: "Email or Password is not correct!")
        }
    }
 
    @IBAction func forgotPassPressed(_ sender: UIButton) {
        presentFromSTB(stbName: "ResetPassword", vcID: "ResetPassword", presentingStyle: .automatic)
    }
    
    private func loginAsEmployeeOrHR(_ asHRorEmployee: @escaping (Bool)->()){
        
        let alert = UIAlertController(title: "", message: "Do you want to sign in as an HR or as an Employee", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Login as HR", style: .destructive, handler: { _ in
            asHRorEmployee(true)
        }))
        alert.addAction(UIAlertAction(title: "Login as Employee", style: .default, handler: { _ in
            asHRorEmployee(false)
        }))
        self.present(alert,animated: true)
    }
    
}

