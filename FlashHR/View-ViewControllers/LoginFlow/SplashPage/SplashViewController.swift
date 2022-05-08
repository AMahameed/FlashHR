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
                self.loginAsEmployeeOrHR { trueIfHR in
                    if trueIfHR{
                        self.presentFromSTB(stbName: "TabBar", vcID: "TabBar")
                    }else{
                        self.presentFromSTB(stbName: "EmployeeTabBar", vcID: "EmployeeTabBar")
                    }
                }
            }else{
                presentFromSTB(stbName: "EmployeeTabBar", vcID: "EmployeeTabBar")
            }
        }
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
