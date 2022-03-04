//
//  EmployeeViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import UIKit

class EmployeeViewController: UIViewController {
    
    @IBOutlet weak var uidLabel: UILabel!
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uidLabel.text = UserDataService.shared.userID
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        loginService.performLogout {
            self.presentFromSTB(stbName: "Login", vcID: "Login")
        } failure: { signOutError in
            self.presentAlert(message: signOutError)
        }
    }
}




