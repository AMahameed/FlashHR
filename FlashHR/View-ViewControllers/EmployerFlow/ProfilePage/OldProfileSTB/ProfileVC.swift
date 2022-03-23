//
//  EmployerViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    private let loginService = LoginService()
    private var flag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius =  userImage.frame.size.height / 5
        
    }
    
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        loginService.performLogout {
            self.presentFromSTB(stbName: "Login", vcID: "Login")
        } failure: { signOutError in
            self.presentAlert(message: signOutError)
        }
        
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        
        guard let text = nameTextField.text, !text.isEmpty,
              let text1 = mobileTextField.text, !text1.isEmpty,
              let text2 = genderTextField.text, !text2.isEmpty else {
                  
                  presentAlert(message: "Please fill all fields properly")
                  return
              }
        
        
        if flag == 0 {
            editButton.title = "Edit"
            nameTextField.borderStyle = UITextField.BorderStyle.none
            nameTextField.isUserInteractionEnabled = false
            mobileTextField.borderStyle = UITextField.BorderStyle.none
            mobileTextField.isUserInteractionEnabled = false
            genderTextField.borderStyle = UITextField.BorderStyle.none
            genderTextField.isUserInteractionEnabled = false

            flag = 1
        }else if flag == 1 {
            editButton.title = "Done"
            nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
            nameTextField.isUserInteractionEnabled = true
            mobileTextField.borderStyle = UITextField.BorderStyle.roundedRect
            mobileTextField.isUserInteractionEnabled = true
            genderTextField.borderStyle = UITextField.BorderStyle.roundedRect
            genderTextField.isUserInteractionEnabled = true

            flag = 0
        }
        
        
    }
    
    
    
    
    
    
}

