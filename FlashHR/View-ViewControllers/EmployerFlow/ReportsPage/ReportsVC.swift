//
//  ReportsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit
import FirebaseFirestore
import ChartProgressBar

class ReportsVC: UIViewController {
    
    @IBOutlet weak var chart1: ChartProgressBar!
    @IBOutlet weak var chart2: ChartProgressBar!
    @IBOutlet var mainView: UIView!
    private let db = Firestore.firestore()
    private var Jan: Float = 0.0
    private var Feb: Float = 0.0
    private var Mar: Float = 0.0
    private var Apr: Float = 0.0
    private var May: Float = 0.0
    private var Jun: Float = 0.0
    private var Jul: Float = 0.0
    private var Aug: Float = 0.0
    private var Sep: Float = 0.0
    private var Oct: Float = 0.0
    private var Nov: Float = 0.0
    private var Dec: Float = 0.0
    var viewDemo = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTotalWorkedHours()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.mainView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            self.progressBar()}
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        chart1.removeClickedBar()
        chart2.removeClickedBar()
    }
    
    private func getTotalWorkedHours(){
        
        db.collection("employee").getDocuments{querySnapshot, error in
            if let error = error {
                self.presentAlertInMainThread(message: error.localizedDescription)
            }else{
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        self.db.collection("employee").document(doc.documentID).collection("workTransactions").addSnapshotListener{ querySnapshot, error in
                            if let error = error{
                                self.presentAlertInMainThread(message: error.localizedDescription)
                            }else{
                                if let documents = querySnapshot?.documents{
                                    for doc in documents {
                                        let doc = doc.data()
                                        if let actualWorkingHoursAsString = doc["actualWorkingHours"] as? String,
                                           let dayStr = doc["dayStr"] as? String{
                                            
                                            if !actualWorkingHoursAsString.isEmpty, !dayStr.isEmpty {
                                                self.covertStrToIntWithSorting(actualWorkingHoursAsString[0 ..< 2], dayStr[3 ..< 5] )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func covertStrToIntWithSorting(_ hoursStr: String, _ dayStr: String){
        
        guard let floatHour = Float(hoursStr) else{return}
        
        switch dayStr {
        case "01":
            Jan += floatHour
        case "02":
            Feb += floatHour
        case "03":
            Mar += floatHour
        case "04":
            Apr += floatHour
        case "05":
            May += floatHour
        case "06":
            Jun += floatHour
        case "07":
            Jul += floatHour
        case "08":
            Aug += floatHour
        case "09":
            Sep += floatHour
        case "10":
            Oct += floatHour
        case "11":
            Nov += floatHour
        case "12":
            Dec += floatHour
        default:
            break
        }
    }
    
    private func progressBar(){
        
        var data1: [BarData] = []
        var data2: [BarData] = []
        
        data1.append(BarData.init(barTitle: "Jan", barValue: Jan, pinText: String(Jan)))
        data1.append(BarData.init(barTitle: "Feb", barValue: Feb, pinText: String(Feb)))
        data1.append(BarData.init(barTitle: "Mar", barValue: Mar, pinText: String(Mar)))
        data1.append(BarData.init(barTitle: "Apr", barValue: Apr, pinText: String(Apr)))
        data1.append(BarData.init(barTitle: "May", barValue: May, pinText: String(May)))
        data1.append(BarData.init(barTitle: "Jun", barValue: Jun, pinText: String(Jun)))
        data2.append(BarData.init(barTitle: "Jul", barValue: Jul, pinText: String(Jul)))
        data2.append(BarData.init(barTitle: "Aug", barValue: Aug, pinText: String(Aug)))
        data2.append(BarData.init(barTitle: "Sep", barValue: Sep, pinText: String(Sep)))
        data2.append(BarData.init(barTitle: "Oct", barValue: Oct, pinText: String(Oct)))
        data2.append(BarData.init(barTitle: "Nov", barValue: Nov, pinText: String(Nov)))
        data2.append(BarData.init(barTitle: "Dec", barValue: Dec, pinText: String(Dec)))
        
        chart1.data = data1
        chart1.barsCanBeClick = true
        chart1.maxValue = 200.0
        chart2.data = data2
        chart2.barsCanBeClick = true
        chart2.maxValue = 200.0
        
        chart1.barWidth = 15
        chart1.barHeight = 180
        chart1.pinTxtColor = UIColor.white
        chart1.pinBackgroundColor = UIColor.darkGray
        chart1.barRadius = 5
        chart1.barTitleTxtSize = 15
        chart1.barTitleWidth = 30
        chart1.barTitleHeight = 25
        chart1.pinTxtSize = 10
        chart1.pinWidth = 30
        chart1.pinHeight = 30
        chart1.build()
        
        chart2.barWidth = 15
        chart2.barHeight = 180
        chart2.pinTxtColor = UIColor.white
        chart2.pinBackgroundColor = UIColor.darkGray
        chart2.barRadius = 5
        chart2.barTitleTxtSize = 15
        chart2.barTitleWidth = 30
        chart2.barTitleHeight = 25
        chart2.pinTxtSize = 10
        chart2.pinWidth = 30
        chart2.pinHeight = 30
        chart2.build()
    }
}

