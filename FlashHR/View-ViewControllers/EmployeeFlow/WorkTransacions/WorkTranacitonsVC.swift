//
//  WorkTranacitonsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/3/22.
//

import UIKit
import Firebase
import CoreLocation

class WorkTranacitonsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet var mainView: UIView!
    var viewDemo = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    private var workTransactions: [WorkTansactions] = []
    private var oldWT: [WorkTansactions] = []
    private var newWT: [WorkTansactions] = []
    private let db = Firestore.firestore()
    private let fireBaseService = FireBaseService()
    static var newWTItem: WorkTansactions?
    static var oldWTItem: WorkTansactions?
    private let manager = CLLocationManager()
    static var lat: Double = 0.0
    static var long: Double = 0.0
    var segmentNoHolder = -1
    var wkNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()

        guard CLLocationManager.locationServicesEnabled() else {
            presentAlert(message: "Please Enable Location Services to continue")
            return
        }

        manager.delegate = self
        manager.requestLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.messgaeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.messgaeCellIdentifier)
        loadAllWorkTransactions()
    }
    
    private func loadAllWorkTransactions(){
        
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
                               let lat = doc["lat"] as? Double,
                               let isWorkedTotally = doc["isWorkedTotally"] as? Bool,
                               let actualStart = doc["actualStart"] as? String,
                               let actualEnd = doc["actualEnd"] as? String,
                               let actualWorkingHours = doc["actualWorkingHours"] as? String{
                                
                                let thisDayWorkTransactions = WorkTansactions( projectName: projectName, contactNo: contactNo, startTime: startTime, dayStr: dayStr,workingHours: workingHours, long: long, lat: lat, isWorkedTotally: isWorkedTotally, actualStart: actualStart, actualEnd: actualEnd, actualWorkingHours: actualWorkingHours)
                                
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dayStr = formatter.string(from: Date())
        
        if dayStr == inputDate {
            return true
        }
        
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
            navigationItem.title = "Available Work"
            tableView.reloadData()
        }else if segmentNoHolder == 0 {
            segmentNoHolder = 1
            navigationItem.title = "Work Records"
            tableView.reloadData()
        }
    }
    
    func activityIndicator() {
        
        viewDemo.center = self.view.center
        viewDemo.backgroundColor = UIColor(named: "myGray")?.withAlphaComponent(0.5)
        viewDemo.layer.cornerRadius = 10
        self.view.addSubview(viewDemo)
        viewDemo.isHidden = false
        
        indicator.style = .large
        indicator.center = viewDemo.center
        self.view.addSubview(indicator)
        
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
            // sending newWt obj to the AvaliableWork VC
            activityIndicator()
            indicator.startAnimating()
            
            WorkTranacitonsVC.newWTItem = newWT[indexPath.row]
            DispatchQueue.main.asyncAfter(deadline: .now() + 8){
                
                self.viewDemo.isHidden = true
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.presentFromSTB(stbName: "AvaliableWork", vcID: "AvaliableWork")
                
            }
        }else{
            // sending oldWt obj to the WorkRecord VC
            activityIndicator()
            indicator.startAnimating()
           
            WorkTranacitonsVC.oldWTItem = oldWT[indexPath.row]
            DispatchQueue.main.asyncAfter(deadline: .now() + 8){
            
                self.viewDemo.isHidden = true
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.presentFromSTB(stbName: "WorkRecord", vcID: "WorkRecord")
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WorkTranacitonsVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            manager.stopUpdatingLocation()
            WorkTranacitonsVC.lat = Double(location.coordinate.latitude)
            WorkTranacitonsVC.long = Double(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
