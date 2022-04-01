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
    var titles = [ "Project Name", "Contact Number", "Start Time", "Working Hours"]
    
    
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
        
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        cell.titleLabel.text = titles[indexPath.row]
        
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
            workingSiteData.startTime = Constants.WorkDetailsVCConstants.startTime[row]
            pickerView.resignFirstResponder()
            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
        case 2:
            workingSiteData.workingHours = Constants.WorkDetailsVCConstants.workingHours[row]
            pickerView.resignFirstResponder()
            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .automatic)
        default:
            return
        }
    }
}

struct WorkingSiteData {

    var startTime: String = ""
    var workingHours: Int = 0
}
