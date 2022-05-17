//
//  SelectedEmpProfileVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/22/22.
//


import UIKit
import FirebaseFirestore

class SelectedEmpProfileVC: UIViewController{
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var empNameTextField: UITextField!
    @IBOutlet weak var tabToEdit: UILabel!
    private var genderPickerView = UIPickerView()
    private var editEmployee = Employee()
    private let db = Firestore.firestore()
    let fireBaseService = FireBaseService()
    var titles = ["Title","Email","Mobile No.","Gender"]
    private var genderTypes = ["Male","Female"]
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.infoCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.infoCellIdentifier)
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        empNameTextField.text = EmployeesVC.empIDHolder.employeeName
        
        tabToEdit.layer.cornerRadius = 7
        tabToEdit.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 5
        infoView.layer.cornerRadius = infoView.frame.size.height / 11
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Beware", message: "Only images with (.png extension with 1 mB size) are allowed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alert,animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func editOrDonePressed(_ sender: Any) {
        if !flag {
            barButton.title = "Done"
            flag = true
        }else{
            barButton.title = "Edit"
            uploadEditedEmployeeInfo()
            flag = false
        }
    }
    
    private func uploadEditedEmployeeInfo() {
        guard !(editEmployee.title.isEmpty), !(editEmployee.mobile.isEmpty), !(editEmployee.gender.isEmpty) else{
            presentAlert(message: "Please fill all required fields"); return}
        
        fireBaseService.getEmpDocID(empID: EmployeesVC.empIDHolder.employeeID) { empDocID in
            self.db.collection("employee").document(empDocID).updateData(
                   ["title" : self.editEmployee.title,
                    "mobile" : self.editEmployee.mobile,
                    "gender" : self.editEmployee.gender])
                self.dismiss(animated: true)
            
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
}


//MARK: - TableView Delegate & DataSource

extension SelectedEmpProfileVC: UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.infoCellIdentifier, for: indexPath) as? infoCell else {return UITableViewCell()}
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        
        fireBaseService.getEmpData(empID: EmployeesVC.empIDHolder.employeeID) { [weak self] empData in
            
            switch indexPath.row {
            case 0:
                cell.textField.text = empData.title
                self?.imageView.image = UIImage(data: empData.empImageData)
            case 1:
                cell.textField.text = empData.email
            case 2:
                cell.textField.text = empData.mobile
            case 3:
                cell.textField.text = empData.gender
            default:
                break
            }
        }
        
        if flag {
            switch indexPath.row {
            case 0:
                cell.textField.text = editEmployee.title
            case 2:
                cell.textField.text = editEmployee.mobile
            case 3:
                cell.textField.inputView = genderPickerView
                cell.textField.text = editEmployee.gender
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
//MARK: - Cell TextField Delegate

extension SelectedEmpProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if flag{
            return true
        }else{
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            textField.isUserInteractionEnabled = false
        case 2:
            textField.keyboardType = .numberPad
        case 3:
            textField.inputView = genderPickerView
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            editEmployee.title = textField.text ?? ""
        case 1:
            editEmployee.email = textField.text ?? ""
        case 2:
            editEmployee.mobile = textField.text ?? ""
        case 3:
            textField.text = editEmployee.gender
        default:
            return
        }
        
        textField.borderStyle = .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - Image Picker

extension SelectedEmpProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        imageView.image = image
        
        guard let imageData = image.pngData() else{
            return
        }
        
        fireBaseService.getEmpDocID(empID: EmployeesVC.empIDHolder.employeeID) { [weak self] docID in
            self?.db.collection("employee").document(docID).setData(["empImageData": imageData], merge: true) { error in
                if let _ = error{
                    self?.presentAlertInMainThread(message: "Image size is more than 1 MB.")
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

extension SelectedEmpProfileVC: UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return genderTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editEmployee.gender = genderTypes[row]
    }
}
