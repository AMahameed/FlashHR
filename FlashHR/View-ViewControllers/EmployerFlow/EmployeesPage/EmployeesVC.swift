//
//  EmployeeVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit

class EmployeesVC: UIViewController {
    
    @IBOutlet weak var searchBarField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeCell", bundle: nil) , forCellReuseIdentifier: "employeeCell")
    }

    @IBAction func addEmployee(_ sender: UIBarButtonItem) {
        
        
    }
}

extension EmployeesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentFromSTB(stbName: "DaysSchedules", vcID: "DaysSchedules")
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 7{
//            return 40
//        }else{
//            return 25
//        }
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
}
