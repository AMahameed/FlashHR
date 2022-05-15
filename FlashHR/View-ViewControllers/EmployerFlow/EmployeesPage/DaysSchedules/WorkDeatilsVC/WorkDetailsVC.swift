//
//  WorkDetailsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class WorkDetailsVC: UIViewController{
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    private var workTransactions = WorkTansactions()
    private var workingHoursPickerView = UIPickerView()
    private var startTimePickerView = UIPickerView()
    private let db = Firestore.firestore()
    private let fireBaseService = FireBaseService()
    
    private var titles = [ "Project Name", "Contact Number", "Assigned Start Time", "Assigned Working Hours","Did he/she work?","Actual Start Shift at", "Actual End Shift at", "Actual Working Hours" ]
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
    
    private func getWorkTransactionDocID(success: @escaping ((String, String)->Void),  failure: @escaping ((String)->Void)){
        
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
                    }
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    
    private func isDayFilled(success: @escaping ((TransactionsHolder)->Void),  failure: @escaping ((String)->Void))  {
        
        getWorkTransactionDocID { [weak self] wtDocID, empDocID in
            
            self?.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener { docSnapShot, e in
                if let error = e {
                    failure(error.localizedDescription)
                }else{
                    
                    if let doc = docSnapShot?.data() {
                        
                        if let dayStr = doc["dayStr"] as? String,
                           let projectName = doc["projectName"] as? String,
                           let contactNo = doc["contactNo"] as? String,
                           let startTime = doc["startTime"] as? String,
                           let workingHours = doc["workingHours"] as? Int,
                           let long = doc["long"] as? Double,
                           let lat = doc["lat"] as? Double,
                           let isWorkedTotally = doc["isWorkedTotally"] as? Bool,
                           let actualStart = doc["actualStart"] as? String,
                           let actualEnd = doc["actualEnd"] as? String,
                           let actualWorkingHours = doc["actualWorkingHours"] as? String{
                            
                            let thisDayWorkTransactions = TransactionsHolder( projectName: projectName, contactNo: contactNo, startTime: startTime, dayStr: dayStr,workingHours: workingHours, long: long, lat: lat, isWorkedTotally: isWorkedTotally, actualStart: actualStart, actualEnd: actualEnd, actualWorkingHours: actualWorkingHours)
                            
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
            presentAlert(message: "Please fill all required fields to continue"); return}
        guard !(workTransactions.long.isZero), !(workTransactions.lat.isZero) else {
            presentAlert(message: "Please Select a Work Location to continue"); return}
        
        fireBaseService.getEmpDocID(empID: EmployeesVC.empIDHolder.employeeID){ empDocID in
            
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(self.wtDocIDHOlder).delete()
            self.db.collection("employee").document(empDocID).collection("workTransactions").addDocument(data: [
                "dayStr" : DaysSchedulesVC.dayIDHolder.dayStr,
                "projectName" : self.workTransactions.projectName,
                "contactNo" : self.workTransactions.contactNo,
                "startTime" : self.workTransactions.startTime,
                "workingHours" : self.workTransactions.workingHours,
                "long": self.workTransactions.long,
                "lat": self.workTransactions.lat,
                "isRequestedLeave": self.workTransactions.isRequestedLeave,
                "isWorked": self.workTransactions.isWorked,
                "isWorkedTotally": self.workTransactions.isWorkedTotally,
                "actualStart": self.workTransactions.actualStart,
                "actualEnd": self.workTransactions.actualEnd,
                "actualWorkingHours": self.workTransactions.actualWorkingHours ])
            
            self.dismiss(animated: true)
            
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
}

//MARK: - TableView

extension WorkDetailsVC: UITableViewDelegate, UITableViewDataSource, GoogleMapsCellDelegate{
    
    func buttonDidClicked() {
        if let vc = UIStoryboard(name: Constants.Segues.MapsView, bundle: nil).instantiateViewController(identifier: Constants.Segues.MapsView) as? MapsViewC {
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
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
            case 4:
                cell.textField.placeholder = String(transHolder.isWorkedTotally)
            case 5:
                cell.textField.placeholder = transHolder.actualStart
            case 6:
                cell.textField.placeholder = transHolder.actualEnd
            case 7:
                cell.textField.placeholder = transHolder.actualWorkingHours
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
        
        if indexPath.row <= 7{
            cell.titleLabel.text = titles[indexPath.row]
            cell.textField.delegate = self
            cell.textField.tag = indexPath.row
        }
        
        switch indexPath.row {
        case 2:
            cell.textField.inputView = self.startTimePickerView
        case 3:
            cell.textField.inputView = self.workingHoursPickerView
        case 4:
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = "N/A"
        case 5:
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = "N/A"
        case 6:
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = "N/A"
        case 7:
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = "N/A"
        case 8:
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
            workTransactions.projectName = textField.text ?? ""
        case 1:
            workTransactions.contactNo = textField.text ?? ""
        case 2:
            textField.text = workTransactions.startTime
        case 3:
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
        workTransactions.long = newLocation.coordinate.longitude
        workTransactions.lat = newLocation.coordinate.latitude
    }
    
    func selectLocationCancelled() {
        presentAlert(message: "No location was selected")
    }
}
