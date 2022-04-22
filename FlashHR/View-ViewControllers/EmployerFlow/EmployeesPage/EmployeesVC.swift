//
//  EmployeeVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit
import Firebase
class EmployeesVC: UIViewController {
    
    
    
    @IBOutlet weak var searchBarField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    static var showEmployee: [Employee] = []
    let loginService = LoginService()
    static var empIDHolder = EmpIDHolder()

    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.NibNames.employeeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.employeeCellIdentifier)
        
        loadEmployees()
    }
    
    @IBAction func addEmployee(_ sender: UIBarButtonItem) {
        
        presentFromSTB(stbName: Constants.Segues.createEmployeeSegue, vcID: Constants.Segues.createEmployeeSegue)
        
    }
    
    
    func loadEmployees(){
        
        db.collection("employee").addSnapshotListener{ querySnapshot, e in
            if let error = e {
                self.presentAlert(message: error.localizedDescription)
            }else{
                
                EmployeesVC.showEmployee.removeAll()
                
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let empName = data["userName"] as? String,
                           let empTitle = data["title"] as? String,
                           let empID = data["empID"] as? String{
                            
                            let employeeInfo = Employee(empID: empID ,userName: empName, title: empTitle)
                            
                            EmployeesVC.showEmployee.append(employeeInfo)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension EmployeesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmployeesVC.showEmployee.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.employeeCellIdentifier , for: indexPath) as! EmployeeCell
        
        cell.empName.text = EmployeesVC.showEmployee[indexPath.row].userName
        cell.empTitle.text = EmployeesVC.showEmployee[indexPath.row].title
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        EmployeesVC.empIDHolder.employeeID = EmployeesVC.showEmployee[indexPath.row].empID
        EmployeesVC.empIDHolder.employeeName = EmployeesVC.showEmployee[indexPath.row].userName
        presentFromSTB(stbName: Constants.Segues.ProfileOrSchedule, vcID: Constants.Segues.ProfileOrSchedule)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        return nil
    }
}

struct EmpIDHolder {
    var employeeID: String = ""
    var employeeName: String = ""
}

