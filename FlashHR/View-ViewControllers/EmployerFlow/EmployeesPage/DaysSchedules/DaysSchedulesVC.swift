//
//  DaysSchedulesVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit
import FSCalendar
import CoreLocation

class DaysSchedulesVC: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var viewBackground: UIView!
    static var dayIDHolder = DayIDHolder()
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
        navigationItem.title = EmployeesVC.empIDHolder.employeeName
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

//MARK: - Calendar Delegate

extension DaysSchedulesVC: FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if Date() > date {
            DaysSchedulesVC.dayIDHolder.canUpdate = false
        }else{
            DaysSchedulesVC.dayIDHolder.canUpdate = true
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        let dayStr = formatter.string(from: date)
        DaysSchedulesVC.dayIDHolder.dayStr = dayStr
        
        presentFromSTB(stbName: Constants.Segues.workDetailsSegue, vcID: Constants.Segues.workDetailsSegue)
    }
}


//MARK: - Holders

struct DayIDHolder {
    var dayStr = ""
    var canUpdate: Bool = true
}
