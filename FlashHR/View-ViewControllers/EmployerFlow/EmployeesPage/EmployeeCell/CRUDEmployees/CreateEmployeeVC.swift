//
//  CreateEmployeeVC.swift
//  FlashHR
//  Created by Abdallah Mahameed on 3/30/22.
//

import UIKit

class CreateEmployeeVC: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    var genderData = GenderData()
    var genderPickerView = UIPickerView()
    var fields = ["User Name", "Email", "Title", "Mobile Number","Gender"]
    var genderTypes = ["Male","Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1
        
        tableView.register(UINib(nibName: "WorkDetailsCell", bundle: nil) , forCellReuseIdentifier: "workDetailsCell")
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
    }
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

//MARK: - TabelView

extension CreateEmployeeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"workDetailsCell", for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        cell.titleLabel.text = fields[indexPath.row]
        
        if indexPath.row == 3 {
            cell.textField.keyboardType = .numberPad
        }
        if indexPath.row == 4{
            cell.textField.inputView = genderPickerView
            cell.setupTextFieldValue(value: genderData.gender)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//MARK: - PickerView

extension CreateEmployeeVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return genderTypes.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return genderTypes[row]
        default:
            return "Data Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            genderData.gender = genderTypes[row]
            pickerView.resignFirstResponder()
            tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .automatic)
        default:
            return
        }
    }
    
}

struct GenderData {
    var gender: String = "Not chosen yet"
}
