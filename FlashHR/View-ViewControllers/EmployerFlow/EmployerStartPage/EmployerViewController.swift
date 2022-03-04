//
//  EmployerViewController.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import UIKit

class EmployerViewController: UIViewController {
    
    @IBOutlet weak var uidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uidLabel.text = UserDataService.shared.userID
    }

    
}
