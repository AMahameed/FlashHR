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
    @IBOutlet weak var imageView: UIImageView!
    var createEmployee = Employee()
    let db = Firestore.firestore()
    var genderPickerView = UIPickerView()
    var fields = ["User Name", "Password", "Email", "Title", "Mobile Number", "Gender"]
    var genderTypes = ["Male","Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentAlert(title: "Warning", message: "Dear User, when creating a new Employee, make sure that all information Provided is correct. Since it is not Editable", preferredStyle: .alert)
        tableView.delegate = self
        tableView.dataSource = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1
        
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 5
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard !(createEmployee.email.isEmpty), !(createEmployee.password.isEmpty),
        !(createEmployee.userName.isEmpty), !(createEmployee.title.isEmpty), !(createEmployee.mobile.isEmpty), !(createEmployee.gender.isEmpty) else{
            presentAlert(message: "Please fill all required fields"); return}
        
        guard !(createEmployee.empImageData.isEmpty) else {
            presentAlert(message: "Please Enter an Image, with size 1 MB or less"); return
        }
        
        loginService.performSignUp(createEmployee) { _ in
        //To send entred values to the firebase
            
            self.db.collection("employee").addDocument(data: [
                "empID" : self.createEmployee.empID,
                "empImageData" : self.createEmployee.empImageData,
                "email" : self.createEmployee.email,
                "password" : self.createEmployee.password,
                "userName" : self.createEmployee.userName,
                "title" : self.createEmployee.title,
                "mobile" : self.createEmployee.mobile,
                "gender" : self.createEmployee.gender,
                "isDeleted" : self.createEmployee.isDeleted])
            
            self.dismiss(animated: true)
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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

//MARK: - Image Picker

extension CreateEmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else{ return}
 
        guard let imageData = image.pngData(), imageData.count >= 103000 else{
            presentAlert(message: "Image size is more than 1 MB.")
            return }
        
        imageView.image = image
        createEmployee.empImageData = imageData
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

//MARK: - TextFieldDelegate

extension CreateEmployeeVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        switch textField.tag {
        case 0:
            createEmployee.userName = textField.text ?? ""
        case 1:
            createEmployee.password = textField.text ?? ""
        case 2:
            createEmployee.email = textField.text ?? ""
        case 3:
            createEmployee.title = textField.text ?? ""
        case 4:
            createEmployee.mobile = textField.text ?? ""
        case 5:
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
