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
        tableView.register(UINib(nibName: Constants.NibNames.employeeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.employeeCellIdentifier)
    }

    @IBAction func addEmployee(_ sender: UIBarButtonItem) {
        
        presentFromSTB(stbName: Constants.Segues.createEmployeeSegue, vcID: Constants.Segues.createEmployeeSegue)
        
    }
}

extension EmployeesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.employeeCellIdentifier , for: indexPath) as! EmployeeCell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentFromSTB(stbName: Constants.Segues.daysSchedulesSegue, vcID: Constants.Segues.daysSchedulesSegue)
    }

    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        return nil
    }
}





        
//        let shareAction = UITableViewRowAction(style: .default, title: "Share" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
//
//        })
//
//        let rateAction = UITableViewRowAction(style: .default, title: "Rate" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
//
//      })
//        // 5
//        return [shareAction,rateAction]
    
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
    

