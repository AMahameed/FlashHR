//
//  EndShiftCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/7/22.
//
protocol EndShiftCellDelegate {
    func failOrSuccess(tag: Int8)
    func proceedEndingSHift(_ complition: @escaping (Bool)->())
}

import UIKit
import Firebase

class EndShiftCell: UITableViewCell {

    @IBOutlet weak var endShiftButt: UIButton!
    var currentlat: Double = 0.0
    var currentlong: Double = 0.0
    private var givenlat: Double = 0.0
    private var givenlong: Double = 0.0
    private let fireBaseService = FireBaseService()
    private let db = Firestore.firestore()
    var delegate: EndShiftCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.endShiftButt.isEnabled = false
        
        endShiftButt.layer.cornerRadius = endShiftButt.frame.size.height / 5
        guard let latitude = WorkTranacitonsVC.oldWTItem?.lat, let longitude = WorkTranacitonsVC.oldWTItem?.long else {return}

        givenlat = roundTo3Decimals(toBeRounded: latitude)
        givenlong = roundTo3Decimals(toBeRounded: longitude)
        currentlat = roundTo3Decimals(toBeRounded: WorkTranacitonsVC.lat)
        currentlong = roundTo3Decimals(toBeRounded: WorkTranacitonsVC.long)
        
        isDayWorked { thisDayWork in
            if thisDayWork{
                self.isDayWorkedTotally { thisDayWorkTotally in
                    if thisDayWorkTotally{
                        self.endShiftButt.isEnabled = false
                    }else{
                        self.endShiftButt.isEnabled = true
                    }
                }
            }else{
                self.endShiftButt.isEnabled = false
            }
        }
    }

    
    @IBAction func endShiftPresssed(_ sender: UIButton) {
        
        if givenlat == currentlat && givenlong == currentlong {
            
            delegate?.proceedEndingSHift({ cancelOrProceed in
                if cancelOrProceed {
                    sender.isEnabled = false
                    self.updateActualEnd(self.convertTimeToString())
                    self.updateIfDayWasWorkedTotally(true)
                    self.actualWorkingHours()
                    
                    self.delegate?.failOrSuccess(tag: 4)
                }
            })
        }else{
            delegate?.failOrSuccess(tag: 5)
            
        }
    }

    //MARK: - Helper Functions

        private func convertTimeToString() -> String{

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let timeStr = formatter.string(from: Date())

            return timeStr
        }

        private func roundTo3Decimals(toBeRounded theValue: Double) -> Double {

            let roundedValue = (round(theValue * 1000) / 1000)
            return roundedValue
        }
    
    //MARK: - Firebase functions
    
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
            self.delegate?.failOrSuccess(tag: 1)
        }
    }

    private func updateIfDayWasWorkedTotally(_ currentIsWorked: Bool) {

        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).updateData([ "isWorkedTotally": currentIsWorked ])
        } failure: { error in
            self.delegate?.failOrSuccess(tag: 2)
        }
    }

    private func updateActualEnd(_ actualEnd: String) {

        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).updateData([ "actualEnd": actualEnd])
        } failure: { error in
            print(error)
        }
    }

    private func isDayWorkedTotally(success: @escaping (Bool)->Void) {

        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener { querySnapShot, _ in

                if let doc = querySnapShot?.data(){
                    if let thisDayWork = doc["isWorkedTotally"] as? Bool{
                        success(thisDayWork)
                    }
                }
            }
        } failure: { error in
            self.delegate?.failOrSuccess(tag: 3)
        }
    }

    private func isDayWorked(success: @escaping (Bool)->Void) {

        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener { querySnapShot, _ in

                if let doc = querySnapShot?.data(){
                    if let thisDayWork = doc["isWorked"] as? Bool{
                        success(thisDayWork)
                    }
                }
            }
        } failure: { error in
            self.delegate?.failOrSuccess(tag: 6)
        }
    }

    private func actualWorkingHours() {

        let nformatter = DateFormatter()
        nformatter.dateFormat = "dd-MM-yyyy HH:mm"
        nformatter.locale = Locale(identifier: "ar_JO")

        getWorkTransactionDocID { wtDocID, empDocID in
            self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).addSnapshotListener { querySnapShot, _ in

                if let doc = querySnapShot?.data(){
                    if let actualStart = doc["actualStart"] as? String{

                        let timeStr = ((WorkTranacitonsVC.oldWTItem?.dayStr)! + " " + actualStart)
                        let startTime = nformatter.date(from: timeStr)

                        let timeStr2 = nformatter.string(from: Date())
                        let endTime = nformatter.date(from: timeStr2)

                        let difference = Calendar.current.dateComponents([.hour, .minute], from: startTime!, to: endTime!)
                        let formattedString = String(format: "%02ld:%02ld", difference.hour!, difference.minute!)

                        self.db.collection("employee").document(empDocID).collection("workTransactions").document(wtDocID).updateData([ "actualWorkingHours": formattedString])
                    }
                }
            }
        } failure: { error in
            self.delegate?.failOrSuccess(tag: 3)
        }
    }
    
}
