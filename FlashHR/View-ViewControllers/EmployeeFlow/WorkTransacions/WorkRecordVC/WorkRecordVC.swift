//
//  WorkRecordVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/5/22.
//

import UIKit
import Firebase

class WorkRecordVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    private let fireBaseService = FireBaseService()
    private let db = Firestore.firestore()
    private var titles = [ "Project Name", "Contact Number", "Assigned Start Time", "Assigned Working Hours","Did he/she work?","Actual Start Shift at", "Actual End Shift at", "Actual Working Hours" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        
        tableView.register(UINib(nibName: "EndShiftCell", bundle: nil), forCellReuseIdentifier: "endShiftCell")
        
        backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 11
        welcomeLabel.text = "Hey, here is your Work Details."
    }
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    //MARK: - Firebase Functions
    
    private func getWorkTransactionDocID(success: @escaping ((String, String)->Void),  failure: @escaping ((String)->Void)){
        
        guard let dayStr = WorkTranacitonsVC.oldWTItem?.dayStr else { return }
        
        fireBaseService.getEmpDocID(empID: UserDataService.shared.userID!) { [weak self] empDocID in
            self?.db.collection("employee").document(empDocID).collection("workTransactions").whereField("dayStr", isEqualTo: dayStr).addSnapshotListener { querySnapshot, e in
                
                if let error = e {
                    failure(error.localizedDescription)
                }else{
                    if let documents = querySnapshot?.documents{
                        for doc in documents{
                            success(doc.documentID, empDocID)
                        }
                    }
                }
            }
        } failure: { error in
        }
    }
    
    private func getUpdatedWT(success: @escaping ((WorkTansactions)->Void)) {
        getWorkTransactionDocID { [weak self] wtDocID, empDocID in
            self?.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener({ querySnapShot, error in
                if let doc = querySnapShot?.data(){
                    
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

                        let thisDayWorkTransactions = WorkTansactions( projectName: projectName, contactNo: contactNo, startTime: startTime, dayStr: dayStr,workingHours: workingHours, long: long, lat: lat, isWorkedTotally: isWorkedTotally, actualStart: actualStart, actualEnd: actualEnd, actualWorkingHours: actualWorkingHours)
                        
                        success(thisDayWorkTransactions)
                    }
                }
            })
        } failure: { error in
            self.presentAlertInMainThread(message: "Sorry, we Couldn't get your data.")
        }

        
    }
    
    
}


//MARK: - TableView Delegate and Data Source

extension WorkRecordVC: UITableViewDataSource, UITableViewDelegate, EndShiftCellDelegate{
    func proceedEndingSHift(_ complition: @escaping (Bool) -> ()) {
        let alert = UIAlertController(title: "Warning", message: "Beware, When you choose to End Shift it means that your actual working hours are counted from the moment you pressed Start Shift till the moment you Press End Shift only.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            complition(false)
        }))
        alert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { _ in
            complition(true)
        }))
        present(alert,animated: true)
    }


    func failOrSuccess(tag: Int8) {
        switch tag {
        case 1:
            presentAlert(message: "Error in retrieving your Data!", preferredStyle: .alert)
        case 2:
            presentAlert(message:"Error in retrieving your Work Transactions!", preferredStyle: .alert)
        case 3:
            presentAlert(message: "coudn't retrieve if the selected day is Worked!", preferredStyle: .alert)
        case 4:
            presentAlert(title: "Well Done", message: "You've Ended your Shift Successfully.")
        case 5:
            presentAlert(message: "You can't End Shift, While being out of work site Location", preferredStyle: .alert)
        case 6:
            presentAlert(message: "coudn't retrieve if the selected day is Worked!", preferredStyle: .alert)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell,
              let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "endShiftCell", for: indexPath) as? EndShiftCell else {return UITableViewCell()}
        
        
        cell.textField.isUserInteractionEnabled = false
        
        if indexPath.row <= 7{
            getUpdatedWT { WT in
                switch indexPath.row {
                case 0:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.projectName
                case 1:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.contactNo
                case 2:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.startTime
                case 3:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = String(WT.workingHours)
                case 4:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = String(WT.isWorkedTotally)
                case 5:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.actualStart
                case 6:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.actualEnd
                case 7:
                    cell.titleLabel.text = self.titles[indexPath.row]
                    cell.textField.text = WT.actualWorkingHours
                default:
                    break
                }
            }
        }
        
        switch indexPath.row {
        case 8:
            buttonsCell.delegate = self
            return buttonsCell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
