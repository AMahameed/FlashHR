//
//  WorkDetailsVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit

class WorkDetailsVC: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var workingSiteData = WorkingSiteData()
    var workingHoursPickerView = UIPickerView()
    var startTimePickerView = UIPickerView()
    var titles = ["Project Name", "Contact Number", "Start Time", "Working Hours"]
    var workingHours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    var startTime = ["00", "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        workingHoursPickerView.delegate = self
        workingHoursPickerView.dataSource = self
        workingHoursPickerView.tag = 2
        startTimePickerView.delegate = self
        startTimePickerView.dataSource = self
        startTimePickerView.tag = 1
        tableView.register(UINib(nibName: "WorkDetailsCell", bundle: nil) , forCellReuseIdentifier: "workDetailsCell")
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
//MARK: - TableView

extension WorkDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"workDetailsCell", for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        cell.titleLabel.text = titles[indexPath.row]
        cell.setupTextFieldValue(value: "")
        if indexPath.row == 2{
            cell.textField.inputView = startTimePickerView
            cell.setupTextFieldValue(value: workingSiteData.startTime)
        }else if indexPath.row == 3{
            cell.textField.inputView = workingHoursPickerView
            cell.setupTextFieldValue(value: String(workingSiteData.workingHours))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            return startTime.count
        case 2:
            return workingHours.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return startTime[row]
        case 2:
            return String(workingHours[row])
        default:
            return "Data Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            workingSiteData.startTime = startTime[row]
            pickerView.resignFirstResponder()
            tableView.reloadData()
        case 2:
            workingSiteData.workingHours = workingHours[row]
            pickerView.resignFirstResponder()
            tableView.reloadData()
        default:
            return
        }
    }
}

struct WorkingSiteData {
    var projectName: String = ""
    var contactNumber: String = ""
    var startTime: String = ""
    var workingHours: Int = 0
}
