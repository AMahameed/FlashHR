//
//  ResetPassViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/1/22.
//

import UIKit

class FirstTimeLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        
    }
    
    
    


}
