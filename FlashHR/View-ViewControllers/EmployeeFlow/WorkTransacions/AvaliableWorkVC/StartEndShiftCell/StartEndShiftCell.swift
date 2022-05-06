//
//  StartEndShiftCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/5/22.
//

import UIKit
import Firebase

protocol StartEndShiftCellDelegate {
    func failOrSuccess(tag: Int8)
}

class StartEndShiftCell: UITableViewCell {

    @IBOutlet weak var startShift: UIButton!
    @IBOutlet weak var endShiftButton: UIButton!
    var currentlat: Double = 0.0
    var currentlong: Double = 0.0
    private var givenlat: Double = 0.0
    private var givenlong: Double = 0.0
    private let fireBaseService = FireBaseService()
    private let db = Firestore.firestore()
    var currentIsWorked: Bool = false
    var delegate: StartEndShiftCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        startShift.layer.cornerRadius = startShift.frame.size.height / 5
        endShiftButton.layer.cornerRadius = endShiftButton.frame.size.height / 5
        
        guard let latitude = WorkTranacitonsVC.newWTItem?.lat, let longitude = WorkTranacitonsVC.newWTItem?.long else { return }

        givenlat = roundTo3Decimals(toBeRounded: latitude)
        givenlong = roundTo3Decimals(toBeRounded: longitude)
        currentlat = roundTo3Decimals(toBeRounded: WorkTranacitonsVC.lat)
        currentlong = roundTo3Decimals(toBeRounded: WorkTranacitonsVC.long)
        
        isDayWorked { thisDayWork in
            if thisDayWork{
                self.endShiftButton.isHidden = false
                self.endShiftButton.isEnabled = false
                self.startShift.isHidden = true
            }else{
                self.endShiftButton.isHidden = true
                self.startShift.isHidden = false
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func startOrEndShift(_ sender: UIButton) {
        
        guard let dayStr = WorkTranacitonsVC.newWTItem?.dayStr else { return }

        if sender.tag == 1 { // start shift was pressed
            if convertDateFormat(inputDate: dayStr)  {
                if givenlat == currentlat && givenlong == currentlong {
                    
                    sender.isHidden = true
                    endShiftButton.isHidden = false
                    endShiftButton.isEnabled = false
                    
                    currentIsWorked = true
                    updateIfDayWasWorked()
                    delegate?.failOrSuccess(tag: 1)
                }else{delegate?.failOrSuccess(tag: 2)}
            }else{delegate?.failOrSuccess(tag: 3)}
            
        }else{
            if givenlat == currentlat && givenlong == currentlong {
                
                sender.isHidden = true
                currentIsWorked = true
//                updateIfDayWasWorked()
                delegate?.failOrSuccess(tag: 4)
            }else{delegate?.failOrSuccess(tag: 5)}
        }
    }
    
    
//MARK: - Helper Functions
    
    private func convertDateFormat(inputDate: String) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dayStr = formatter.string(from: Date())
        
        if dayStr == inputDate {
            return true
        }
        return false
    }
    
    func roundTo3Decimals(toBeRounded theValue: Double) -> Double {
        
        let roundedValue = (round(theValue * 1000) / 1000)
        return roundedValue
    }
    
//MARK: - Firebase functions
    
    private func getWorkTransactionDocID(success: @escaping ((String, String)->Void),  failure: @escaping ((String)->Void)){
        
        guard let dayStr = WorkTranacitonsVC.newWTItem?.dayStr else { return }
        
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
            print(error)
        }
    }
    
    
    func updateIfDayWasWorked() {
        
        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).updateData([ "isWorked": self.currentIsWorked ])
        } failure: { error in
            print(error)
        }
    }
    
    
    func isDayWorked(success: @escaping (Bool)->Void) {
        
        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener { querySnapShot, _ in
                
                if let doc = querySnapShot?.data(){
                    if let thisDayWork = doc["isWorked"] as? Bool{
                        success(thisDayWork)
                    }
                }
            }
        } failure: { error in
            print(error)
        }
    }
}
