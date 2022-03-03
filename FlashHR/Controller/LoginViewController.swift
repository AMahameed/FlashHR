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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        
    }

    @IBAction func submitPressed(_ sender: UIButton) {
    

        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if authResult?.user.uid == Constants.Strings.employerID{ // to check if the employer or another person is logging in
                        self.performSegue(withIdentifier: Constants.Segues.employerSegue ,sender: self)
                        
                    }else{
                        if (Auth.auth().currentUser?.metadata.lastSignInDate?.timeIntervalSinceNow.rounded().isZero == true) { // to check if the user is a new user
                            self.performSegue(withIdentifier: Constants.Segues.firstTimeLoginSegue ,sender: self)
                        }else{
                            self.performSegue(withIdentifier: Constants.Segues.employeeSegue ,sender: self)
                        }
                    }
                }
            }
        }
    }
 
    @IBAction func forgotPassPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.resetPassSegue ,sender: self)
    }
    
}

