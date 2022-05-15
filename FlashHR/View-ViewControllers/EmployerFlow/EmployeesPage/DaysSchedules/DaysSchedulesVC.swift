//
//  DaysSchedulesVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit
import FSCalendar

class DaysSchedulesVC: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var label: UILabel!
    static var dayIDHolder = DayIDHolder()
    private let helperService = HelperServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
        navigationItem.title = "Work Schedule"
        
        label.attributedText = helperService.partialBoldString(EmployeesVC.empIDHolder.employeeName, "Select a Work Day for ")
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
} 
//MARK: - Calendar Delegate

extension DaysSchedulesVC: FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        let dayStr = formatter.string(from: date)
        DaysSchedulesVC.dayIDHolder.dayStr = dayStr
        let todaysDate = formatter.string(from: Date())
        
        
        if Date() < date || todaysDate == dayStr {
            DaysSchedulesVC.dayIDHolder.canUpdate = true
        }else{
            DaysSchedulesVC.dayIDHolder.canUpdate = false
        }
        
        
        
        presentFromSTB(stbName: Constants.Segues.workDetailsSegue, vcID: Constants.Segues.workDetailsSegue)
    }
}


//MARK: - Holders

struct DayIDHolder {
    var dayStr = ""
    var canUpdate: Bool = true
}
