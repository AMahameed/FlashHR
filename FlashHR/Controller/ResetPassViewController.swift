//
//  ResetPassViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/1/22.
//

import UIKit
import Firebase
import FirebaseAuth
class ResetPassViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if let email = emailTextField.text{
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error{
                    print(e)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
