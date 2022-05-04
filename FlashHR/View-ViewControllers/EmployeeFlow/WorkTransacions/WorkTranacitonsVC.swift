//
//  WorkTranacitonsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/3/22.
//

import UIKit
import Firebase

protocol WorkTransactionsDelegate {
    func workTransactionsObject(wt: [WorkTansactions])
}

class WorkTranacitonsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    private var workTransactions: [WorkTansactions] = []
    private var oldWT: [WorkTansactions] = []
    private var newWT: [WorkTansactions] = []
    private let db = Firestore.firestore()
    private let fireBaseService = FireBaseService()
    var delegate: WorkTransactionsDelegate?
    
    var segmentNoHolder = -1
    var wkNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.messgaeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.messgaeCellIdentifier)
        
        loadAllWorkTransactions()
    }
    
    private func loadAllWorkTransactions(){ //success: @escaping ([WorkTansactions])->Void ){
        
        if let empID = UserDataService.shared.userID{
            
            fireBaseService.getEmpDocID(empID: empID) { [weak self] empDocID in
                self?.db.collection("employee").document(empDocID).collection("workTransactions").addSnapshotListener { docSnapShot, _ in
                    
                    self?.workTransactions.removeAll()
                    
                    if let documents = docSnapShot?.documents {
                        for document in documents{
                            let doc = document.data()
                            
                            if let dayStr = doc["dayStr"] as? String,
                               let projectName = doc["projectName"] as? String,
                               let contactNo = doc["contactNo"] as? String,
                               let startTime = doc["startTime"] as? String,
                               let workingHours = doc["workingHours"] as? Int,
                               let long = doc["long"] as? Double,
                               let lat = doc["lat"] as? Double{
                                
                                let thisDayWorkTransactions = WorkTansactions( projectName: projectName, contactNo: contactNo, startTime: startTime, dayStr: dayStr,workingHours: workingHours, long: long, lat: lat)
                                
                                self?.workTransactions.append(thisDayWorkTransactions)
                                
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                        self?.sortWT()
                    }
                }
            } failure: { error in
                self.presentAlertInMainThread(message: error)
            }
        }
    }
    
    private func sortWT() {
        
        // after calling the func convertDateFormat it appends it in the old or the new depending on the date.
        while wkNumber < workTransactions.count {
            
            if convertDateFormat(inputDate: workTransactions[wkNumber].dayStr){
                newWT.append(workTransactions[wkNumber])
            }else{
                oldWT.append(workTransactions[wkNumber])
            }
            wkNumber += 1
        }
        // sorting
        newWT = newWT.sorted(by: { $0.dayStr > $1.dayStr }).reversed()
        oldWT = oldWT.sorted(by: { $0.dayStr > $1.dayStr }).reversed()
        
        if segment.selectedSegmentIndex == 0 {
            segmentNoHolder = 0
        }else if segment.selectedSegmentIndex == 1 {
            segmentNoHolder = 1
        }
    }
    
    // checking whether the date is newer than today's date or not
    private func convertDateFormat(inputDate: String) -> Bool {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.locale = NSLocale.current
        olDateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let oldDate = olDateFormatter.date(from: inputDate)?.timeIntervalSince1970{
            if Date().timeIntervalSince1970 > oldDate{
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl){
        
        if segmentNoHolder == 1 {
            segmentNoHolder = 0
            tableView.reloadData()
        }else if segmentNoHolder == 0 {
            segmentNoHolder = 1
            tableView.reloadData()
        }
    }
}

//MARK: - TableView Delegate and Data Source

extension WorkTranacitonsVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentNoHolder == 0{
            return newWT.count
        }else{ //if segmentNoHolder == 1{
            return oldWT.count
        }
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.messgaeCellIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}
        
        guard !workTransactions.isEmpty, !newWT.isEmpty, !oldWT.isEmpty else{return UITableViewCell()}
        
        
        if segmentNoHolder == 0{
            cell.senderLabel.text = newWT[indexPath.row].projectName
            cell.bodyLabel.text = newWT[indexPath.row].dayStr
            return cell
        }else{ //if segmentNoHolder == 1{
            cell.senderLabel.text = oldWT[indexPath.row].projectName
            cell.bodyLabel.text = oldWT[indexPath.row].dayStr
            return cell
        }
//        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentNoHolder == 0{
            // sending newWt obj to the next VC
            delegate?.workTransactionsObject(wt: newWT)
            presentFromSTB(stbName: "AvaliableWork", vcID: "AvaliableWork")
        }else{
            // sending oldWt obj to the next VC
            delegate?.workTransactionsObject(wt: oldWT)
            presentFromSTB(stbName: "WorkRecord", vcID: "WorkRecord")
        }
    }
}

struct EmpDocsHolder {
    var dayStr: String = ""
}
