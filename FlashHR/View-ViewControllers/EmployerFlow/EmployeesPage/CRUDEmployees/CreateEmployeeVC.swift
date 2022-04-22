//
//  CreateEmployeeVC.swift
//  FlashHR
//  Created by Abdallah Mahameed on 3/30/22.
//

import UIKit
import Firebase

class CreateEmployeeVC: UIViewController {
    
    private let loginService = LoginService()
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var createEmployee = Employee()
    let db = Firestore.firestore()
    var genderPickerView = UIPickerView()
    var fields = ["User Name", "Password", "Email", "Title", "Mobile Number", "Gender"]
    var genderTypes = ["Male","Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1
        
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard !(createEmployee.email.isEmpty), !(createEmployee.password.isEmpty),
        !(createEmployee.userName.isEmpty), !(createEmployee.title.isEmpty), !(createEmployee.mobile.isEmpty), !(createEmployee.gender.isEmpty) else{
            presentAlert(message: "Please fill all required fields"); return}
        
        loginService.performSignUp(createEmployee) { _ in
        //To send entred values to the firebase
            
            self.db.collection("employee").addDocument(data: [
                "empID" : self.createEmployee.empID,
                "email" : self.createEmployee.email,
                "password" : self.createEmployee.password,
                "userName" : self.createEmployee.userName,
                "title" : self.createEmployee.title,
                "mobile" : self.createEmployee.mobile,
                "gender" : self.createEmployee.gender,
                "isDeleted" : self.createEmployee.isDeleted])
            { error in
                    self.presentAlert(message: error?.localizedDescription ?? "No Data Found")
            }
            
            self.dismiss(animated: true)
        } failure: { error in
            self.presentAlert(message: error)
        }
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        cell.titleLabel.text = fields[indexPath.row]
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        
        switch indexPath.row {
        case 1:
            cell.textField.isSecureTextEntry = true
        case 4:
            cell.textField.keyboardType = .numberPad
        case 5:
            cell.textField.inputView = genderPickerView
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//MARK: - TextFieldDelegate

extension CreateEmployeeVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        switch textField.tag {
        case 0:
            //userName
            createEmployee.userName = textField.text ?? ""
        case 1:
            //password
            createEmployee.password = textField.text ?? ""
        case 2:
            //email
            createEmployee.email = textField.text ?? ""
        case 3:
            //title
            createEmployee.title = textField.text ?? ""
        case 4:
            //mobile No.
            createEmployee.mobile = textField.text ?? ""
        case 5:
            //gender has already been entered from the pickerView unlike other attributes
            textField.text = createEmployee.gender
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
            createEmployee.gender = genderTypes[row]
//            tableView.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .automatic)
        default:
            return
        }
    }
}
