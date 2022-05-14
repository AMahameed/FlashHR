//
//  ProfileOrScheduleVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/22/22.
//

import UIKit

class ProfileOrScheduleVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = EmployeesVC.empIDHolder.employeeName
        
        scheduleButton.layer.cornerRadius = scheduleButton.frame.size.height / 5
        profileButton.layer.cornerRadius = profileButton.frame.size.height / 5
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func scheduleButtonPressed(_ sender: UIButton) {
        presentFromSTB(stbName: Constants.Segues.daysSchedulesSegue, vcID: Constants.Segues.daysSchedulesSegue)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        presentFromSTB(stbName: Constants.Segues.SelectedEmpProfile, vcID: Constants.Segues.SelectedEmpProfile)
    }
}
