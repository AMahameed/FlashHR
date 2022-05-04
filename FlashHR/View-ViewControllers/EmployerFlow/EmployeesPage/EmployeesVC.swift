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
    var filteredEmployees: [Employee] = []
    let loginService = LoginService()
    static var empIDHolder = EmpIDHolder()
    @IBOutlet weak var searchBar: UISearchBar!
    private let db = Firestore.firestore()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.employeeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.employeeCellIdentifier)
        
        searchBar.delegate = self
        
        loadEmployees()
    }
    
    @IBAction func addEmployee(_ sender: UIBarButtonItem) {
        
        presentFromSTB(stbName: Constants.Segues.createEmployeeSegue, vcID: Constants.Segues.createEmployeeSegue)
        
    }
    
    func loadEmployees(){
        
        db.collection("employee").addSnapshotListener{ [weak self] querySnapshot, e in
            if let error = e {
                self?.presentAlertInMainThread(message: error.localizedDescription)
            }else{
                
                EmployeesVC.showEmployee.removeAll()
                
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let empName = data["userName"] as? String,
                           let empImageData = doc["empImageData"] as? Data,
                           let empTitle = data["title"] as? String,
                           let empID = data["empID"] as? String{
                            
                            let employeeInfo = Employee(empID: empID, empImageData: empImageData, userName: empName, title: empTitle)
                            
                            EmployeesVC.showEmployee.append(employeeInfo)
                            
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - TableView Delegate and DataScource

extension EmployeesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredEmployees.count == 0{
            return EmployeesVC.showEmployee.count
        }else{
            return filteredEmployees.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.employeeCellIdentifier , for: indexPath) as? EmployeeCell else {return UITableViewCell()}
        
        if filteredEmployees.count == 0 {
            cell.empName.text = EmployeesVC.showEmployee[indexPath.row].userName
            cell.empTitle.text = EmployeesVC.showEmployee[indexPath.row].title
            let image = UIImage(data: EmployeesVC.showEmployee[indexPath.row].empImageData)
            cell.empImage.image = image
            return cell
        }else{
            cell.empName.text = filteredEmployees[indexPath.row].userName
            cell.empTitle.text = filteredEmployees[indexPath.row].title
            let image = UIImage(data: filteredEmployees[indexPath.row].empImageData)
            cell.empImage.image = image
            return cell
        } 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filteredEmployees.count == 0 {
            EmployeesVC.empIDHolder.employeeID = EmployeesVC.showEmployee[indexPath.row].empID
            EmployeesVC.empIDHolder.employeeName = EmployeesVC.showEmployee[indexPath.row].userName
            presentFromSTB(stbName: Constants.Segues.ProfileOrSchedule, vcID: Constants.Segues.ProfileOrSchedule)
        }else{
            EmployeesVC.empIDHolder.employeeID = filteredEmployees[indexPath.row].empID
            EmployeesVC.empIDHolder.employeeName = filteredEmployees[indexPath.row].userName
            presentFromSTB(stbName: Constants.Segues.ProfileOrSchedule, vcID: Constants.Segues.ProfileOrSchedule)
        }
    }
}

//MARK: - SearchBar Delegate

extension EmployeesVC: UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredEmployees = []
        
        if searchText.isEmpty {
            filteredEmployees = EmployeesVC.showEmployee
        }
        
        for emp in EmployeesVC.showEmployee{
            
            if emp.userName.uppercased().contains(searchText.uppercased()){
                filteredEmployees.append(emp)
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

struct EmpIDHolder {
    var employeeID: String = ""
    var employeeName: String = ""
}

