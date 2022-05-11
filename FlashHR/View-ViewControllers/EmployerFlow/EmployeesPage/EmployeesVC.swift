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
    let fireBaseService = FireBaseService()
    var allEmployees: [Employee] = []
    var filteredEmployees: [Employee] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let loginService = LoginService()
    static var empIDHolder = EmpIDHolder()
    @IBOutlet weak var searchBar: UISearchBar!
    private let db = Firestore.firestore()
    
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
    
    func sortEmployeesByDeletion() {
        let deletedEmployees = allEmployees.filter({$0.isDeleted})
        let activeEmployees = allEmployees.filter({!$0.isDeleted})
        allEmployees = []
        allEmployees.append(contentsOf: activeEmployees)
        allEmployees.append(contentsOf: deletedEmployees)
        self.filteredEmployees = self.allEmployees
    }
    
    func loadEmployees(){
        
        db.collection("employee").addSnapshotListener{ [weak self] querySnapshot, e in
    
            guard let self = self else {return}
            self.allEmployees = []
            if let error = e {
                self.presentAlertInMainThread(message: error.localizedDescription)
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let empName = data["userName"] as? String,
                           let empImageData = doc["empImageData"] as? Data,
                           let empTitle = data["title"] as? String,
                           let empID = data["empID"] as? String,
                           let isDeleted = data["isDeleted"] as? Bool{
                            
                            let employeeInfo = Employee(empID: empID, empImageData: empImageData, userName: empName, title: empTitle, isDeleted: isDeleted)
                            
                            self.allEmployees.append(employeeInfo)
                        }
                    }
                    self.sortEmployeesByDeletion()
                }else{
                    self.allEmployees = []
                }
            }
        }
    }
    
    private func deleteAction(rowIndexPathAT indexPath: IndexPath, typeOfSwipe deleteOrUndelete: Bool, _ title: String) -> UIContextualAction {
        
        let deleteAction = UIContextualAction(style: .destructive, title: title) { _, _, _ in
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to \(title) (\(self.filteredEmployees[indexPath.row].userName))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: title, style: .destructive, handler: { _ in
                
                self.fireBaseService.getEmpDocID(empID: self.filteredEmployees[indexPath.row].empID) { empDocID in
                    if deleteOrUndelete{
                        self.filteredEmployees[indexPath.row].isDeleted.toggle()
                        self.db.collection("employee").document(empDocID).updateData(["isDeleted" : true])
                    }else{
                        self.filteredEmployees[indexPath.row].isDeleted.toggle()
                        self.db.collection("employee").document(empDocID).updateData(["isDeleted" : false])
                    }
                } failure: { error in
                    self.presentAlertInMainThread(message: "Error proccessing Employee")
                }
            }))
            self.present(alert,animated: true)
        }
        return deleteAction
    }
    
}

//MARK: - TableView Delegate and DataScource

extension EmployeesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEmployees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.employeeCellIdentifier , for: indexPath) as? EmployeeCell else {return UITableViewCell()}
        
        cell.setupCell(empName: filteredEmployees[indexPath.row].userName, empTitle: filteredEmployees[indexPath.row].title, img: filteredEmployees[indexPath.row].empImageData, isDeleted: filteredEmployees[indexPath.row].isDeleted)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EmployeesVC.empIDHolder.employeeID = filteredEmployees[indexPath.row].empID
        EmployeesVC.empIDHolder.employeeName = filteredEmployees[indexPath.row].userName
        presentFromSTB(stbName: Constants.Segues.ProfileOrSchedule, vcID: Constants.Segues.ProfileOrSchedule)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let isDeletedTitle = filteredEmployees[indexPath.row].isDeleted ? "Activate" : "Deactivate"
        
        if !filteredEmployees[indexPath.row].isDeleted{
            let deleteAction = deleteAction(rowIndexPathAT: indexPath, typeOfSwipe: true, isDeletedTitle)
            let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipe
        }else{
            let unDeleteAction = deleteAction(rowIndexPathAT: indexPath, typeOfSwipe: false, isDeletedTitle)
            let swipe = UISwipeActionsConfiguration(actions: [unDeleteAction])
            return swipe
        }
    }
}

//MARK: - SearchBar Delegate

extension EmployeesVC: UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            filteredEmployees = allEmployees
            return
        }
        filteredEmployees = allEmployees.filter({$0.userName.localizedCaseInsensitiveContains(searchText)})
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredEmployees = allEmployees
        searchBar.resignFirstResponder()
    }
}

struct EmpIDHolder {
    var employeeID: String = ""
    var employeeName: String = ""
}

