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
    @IBOutlet weak var empNameTextField: UITextField!
    @IBOutlet weak var tabToEdit: UILabel!
    private let db = Firestore.firestore()
    let fireBaseService = FireBaseService()
    var titles = ["Title","Email","Mobile No.","Gender"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.infoCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.infoCellIdentifier)
        
        empNameTextField.text = EmployeesVC.empIDHolder.employeeName
        
        tabToEdit.layer.cornerRadius = 8
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
//MARK: - Cell TextField Delegate

extension SelectedEmpProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
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
