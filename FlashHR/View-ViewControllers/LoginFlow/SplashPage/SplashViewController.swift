//
//  SplashViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserData()
    }

    private func checkUserData() {
        if UserDataService.shared.userID == nil  {
            presentFromSTB(stbName: "Login", vcID: "Login")
        }else {
            if UserDataService.shared.isEmployeer{
                presentFromSTB(stbName: "Employer", vcID: "Employer")
            }else{
                presentFromSTB(stbName: "Employee", vcID: "Employee")
            }
        }
    }
}
