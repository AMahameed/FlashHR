//
//  WorkDetailsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit
import Firebase

class WorkDetailsVC: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var workTransactions = WorkTansactions()
    var documentsIDHolder = DocumentsIDHolder()
    var workingHoursPickerView = UIPickerView()
    var startTimePickerView = UIPickerView()
    let db = Firestore.firestore()
    var titles = [ "Project Name", "Contact Number", "Start Time", "Working Hours"]
    var wtDocIDHOlder: String = "no data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        startTimePickerView.delegate = self
        startTimePickerView.dataSource = self
        startTimePickerView.tag = 1
        
        workingHoursPickerView.delegate = self
        workingHoursPickerView.dataSource = self
        workingHoursPickerView.tag = 2
        
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
        
        navigationItem.title = EmployeesVC.empIDHolder.employeeName
    }
    

    func getEmpDocID(success: @escaping ((String)->Void),  failure: @escaping ((String)->Void)){

        db.collection("employee").whereField("empID", isEqualTo: EmployeesVC.empIDHolder.employeeID).getDocuments {querySnapshot, e in
            if let error = e {
                failure(error.localizedDescription)
            }else{
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        self.documentsIDHolder.empDocumentID = doc.documentID
                        
                        success(self.documentsIDHolder.empDocumentID)
                    }
                }
            }
        }
    }

    func getWorkTransactionDocID(success: @escaping ((String, String)->Void),  failure: @escaping ((String)->Void)){

        getEmpDocID { empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").whereField("dayNo", isEqualTo: DaysSchedulesVC.dayIDHolder.dayID).addSnapshotListener { querySnapshot, e in

                if let error = e {
                    failure(error.localizedDescription)
                }else{
                    if let documents = querySnapshot?.documents{
                        for doc in documents{
                            self.documentsIDHolder.workTransactionsDocumentID = doc.documentID
                            self.wtDocIDHOlder = doc.documentID
                            success(self.documentsIDHolder.workTransactionsDocumentID, empDocID)
                        }
                    }
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }


    func isDayFilled(success: @escaping ((TansactionsHolder)->Void),  failure: @escaping ((String)->Void))  {

        getWorkTransactionDocID { wtDocID, empDocID in

            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).getDocument { docSnapShot, e in
                if let error = e {
                    failure(error.localizedDescription)
                }else{

                    if let document = docSnapShot?.data() {

                        let doc = document

                        if let dayNo = doc["dayNo"] as? Int,
                           let projectName = doc["projectName"] as? String,
                           let contactNo = doc["contactNo"] as? String,
                           let startTime = doc["startTime"] as? String,
                           let workingHours = doc["workingHours"] as? Int{

                            let thisDayWorkTransactions = TansactionsHolder( projectName: projectName, contactNo: contactNo, startTime: startTime, dayNo: dayNo, workingHours: workingHours)

                            success(thisDayWorkTransactions)
                        }
                    }
                }
            }

        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    

    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    
        guard !(workTransactions.projectName.isEmpty), !(workTransactions.contactNo.isEmpty),!(workTransactions.startTime.isEmpty) else{
            presentAlert(message: "Please fill all required fields"); return}
        
        
        
            getEmpDocID { empDocID in
                self.db.collection("employee").document(empDocID).collection("workTransactions").document(self.wtDocIDHOlder).delete()
                self.db.collection("employee").document(empDocID).collection("workTransactions").addDocument(data: [
                    "dayNo" : DaysSchedulesVC.dayIDHolder.dayID,
                    "projectName" : self.workTransactions.projectName,
                    "contactNo" : self.workTransactions.contactNo,
                    "startTime" : self.workTransactions.startTime,
                    "workingHours" : self.workTransactions.workingHours,
                    "date": Date().timeIntervalSince1970,
                    "isRequestedLeave": self.workTransactions.isRequestedLeave])

                self.dismiss(animated: true)

            } failure: { error in
                self.presentAlertInMainThread(message: error)
            }
    }
    
}
//MARK: - TableView

extension WorkDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        isDayFilled { Tansactionsholder in

            switch indexPath.row {
            case 0:
                cell.textField.placeholder = Tansactionsholder.projectName
            case 1:
                cell.textField.placeholder = Tansactionsholder.contactNo
            case 2:
                cell.textField.placeholder = Tansactionsholder.startTime
            case 3:
                cell.textField.placeholder = String(Tansactionsholder.workingHours)
            default:
                break
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        
        switch indexPath.row {
        case 2:
            cell.textField.inputView = startTimePickerView
        case 3:
            cell.textField.inputView = workingHoursPickerView
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - TextFieldDelegate

extension WorkDetailsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            //projectName
            workTransactions.projectName = textField.text ?? ""
        case 1:
            //contactNo
            workTransactions.contactNo = textField.text ?? ""
        case 2:
            //startTime
            textField.text = workTransactions.startTime
        case 3:
            //workingHours
            textField.text = String(workTransactions.workingHours)
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}


//MARK: - Start Time PickerView & Working Hours PickerView

extension WorkDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Constants.WorkDetailsVCConstants.startTime.count
        case 2:
            return Constants.WorkDetailsVCConstants.workingHours.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return Constants.WorkDetailsVCConstants.startTime[row]
        case 2:
            return String(Constants.WorkDetailsVCConstants.workingHours[row])
        default:
            return "Data Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            workTransactions.startTime = Constants.WorkDetailsVCConstants.startTime[row]
            //            pickerView.resignFirstResponder()
            //            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
        case 2:
            workTransactions.workingHours = Constants.WorkDetailsVCConstants.workingHours[row]
            //            pickerView.resignFirstResponder()
            //            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .automatic)
        default:
            return
        }
    }
}
