//
//  WorkDetailsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit
import Firebase
import CoreLocation

class WorkDetailsVC: UIViewController{

    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var workTransactions = WorkTansactions()
    var workingHoursPickerView = UIPickerView()
    var startTimePickerView = UIPickerView()
    let db = Firestore.firestore()
    let fireBaseService = FireBaseService()
    
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
        
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        tableView.register(UINib(nibName: Constants.NibNames.GoogleMapsCell , bundle: nil), forCellReuseIdentifier: Constants.Identifiers.GoogleMapsCellIdentifier)
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
        
        nameLabel.text = EmployeesVC.empIDHolder.employeeName
        dayLabel.text = DaysSchedulesVC.dayIDHolder.dayStr
        
        if !DaysSchedulesVC.dayIDHolder.canUpdate {
            navigationItem.rightBarButtonItem?.isEnabled = false
            presentAlert(title:" Warning", message: "This Record has already been done. No Manipulation of older records is allowed! ", preferredStyle: .alert )
        }
    }
    
    func getWorkTransactionDocID(success: @escaping ((String, String)->Void),  failure: @escaping ((String)->Void)){
        
        fireBaseService.getEmpDocID(empID: EmployeesVC.empIDHolder.employeeID) { [weak self] empDocID in
            self?.db.collection("employee").document(empDocID).collection("workTransactions").whereField("dayStr", isEqualTo: DaysSchedulesVC.dayIDHolder.dayStr).addSnapshotListener { querySnapshot, e in
                
                if let error = e {
                    failure(error.localizedDescription)
                }else{
                    if let documents = querySnapshot?.documents{
                        for doc in documents{
                            self?.wtDocIDHOlder = doc.documentID
                            success(doc.documentID, empDocID)
                        }
//                        guard documents.count != 0 else { self?.presentAlert(title:" Warning", message: "No Records Found for this day.", preferredStyle: .alert)
//                            return }
                    }
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    
    func isDayFilled(success: @escaping ((TransactionsHolder)->Void),  failure: @escaping ((String)->Void))  {
        
        getWorkTransactionDocID { [weak self] wtDocID, empDocID in
            
            self?.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).getDocument { docSnapShot, e in
                if let error = e {
                    failure(error.localizedDescription)
                }else{
                    
                    if let doc = docSnapShot?.data() {
                        
                        if let dayStr = doc["dayStr"] as? String,
                           let projectName = doc["projectName"] as? String,
                           let contactNo = doc["contactNo"] as? String,
                           let startTime = doc["startTime"] as? String,
                           let workingHours = doc["workingHours"] as? Int{
                            
                            
                            let thisDayWorkTransactions = TransactionsHolder( projectName: projectName, contactNo: contactNo, startTime: startTime, dayStr: dayStr,workingHours: workingHours)
                            
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
        
        fireBaseService.getEmpDocID(empID: EmployeesVC.empIDHolder.employeeID){ empDocID in
            
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(self.wtDocIDHOlder).delete()
            self.db.collection("employee").document(empDocID).collection("workTransactions").addDocument(data: [
                "dayStr" : DaysSchedulesVC.dayIDHolder.dayStr,
                "projectName" : self.workTransactions.projectName,
                "contactNo" : self.workTransactions.contactNo,
                "startTime" : self.workTransactions.startTime,
                "workingHours" : self.workTransactions.workingHours,
                "isRequestedLeave": self.workTransactions.isRequestedLeave])
            
            self.dismiss(animated: true)
            
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    
}

//MARK: - TableView

extension WorkDetailsVC: UITableViewDelegate, UITableViewDataSource, GoogleMapsCellDelegate{
    
    func buttonDidClicked() {
        if let vc = UIStoryboard(name: Constants.Segues.MapsView, bundle: Bundle.main).instantiateViewController(identifier: Constants.Segues.MapsView) as? MapsViewC {
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        guard let googleMapsCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.GoogleMapsCellIdentifier, for: indexPath) as? GoogleMapsCell else {return UITableViewCell()}
        
        isDayFilled { transHolder in

            switch indexPath.row {
            case 0:
                cell.textField.placeholder = transHolder.projectName
            case 1:
                cell.textField.placeholder = transHolder.contactNo
            case 2:
                cell.textField.placeholder = transHolder.startTime
            case 3:
                cell.textField.placeholder = String(transHolder.workingHours)
            default:
                break
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
        
        if !DaysSchedulesVC.dayIDHolder.canUpdate{
            cell.textField.isUserInteractionEnabled = false
            googleMapsCell.locationButton.isUserInteractionEnabled = false
        }
        
        if indexPath.row <= 3{
            cell.titleLabel.text = titles[indexPath.row]
            cell.textField.delegate = self
            cell.textField.tag = indexPath.row}
        
        switch indexPath.row {
        case 2:
            cell.textField.inputView = self.startTimePickerView
        case 3:
            cell.textField.inputView = self.workingHoursPickerView
        case 4:
            googleMapsCell.delegate = self
            return googleMapsCell
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
        case 2:
            workTransactions.workingHours = Constants.WorkDetailsVCConstants.workingHours[row]
        default:
            break
        }
    }
}
//MARK: - GoogleMapsVC Delegate

extension WorkDetailsVC: MapsViewCDelegate{
    
    func locationConfirmed(newLocation: CLLocation) {
        print(newLocation.coordinate.longitude)
        print(newLocation.coordinate.latitude)
    }
    
    func selectLocationCancelled() {
        print("error 111")
    }
    
}








//func isDayDetailsUpdatable()  {
//
//    isDayFilled { transactionsHolder in
//
//        let x = Double(Date().timeIntervalSince1970) - transactionsHolder.date
//        print(x)
//
//        let today = Date()
//        let c = Date(timeIntervalSince1970: transactionsHolder.date).timeIntervalSince1970
//        let mc = Calendar.current.date(byAdding: .day, value: -7, to: today)?.timeIntervalSince1970
//
//
//        if c < mc! {
//            print(c)
//        }else{
//            print(mc!)
//        }
//
//
//    } failure: { error in
//        self.presentAlertInMainThread(message: error)
//    }
//}
