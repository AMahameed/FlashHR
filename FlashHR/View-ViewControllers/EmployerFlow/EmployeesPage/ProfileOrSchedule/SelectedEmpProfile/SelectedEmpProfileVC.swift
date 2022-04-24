//
//  SelectedEmpProfileVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/22/22.
//


import UIKit
import Firebase

class SelectedEmpProfileVC: UIViewController{
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var empNameLabel: UILabel!
    private let db = Firestore.firestore()
    var documentsIDHolder = DocumentsIDHolder()
    var titles = ["Title","Email","Mobile No.","Gender"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.infoCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.infoCellIdentifier)
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 5
        infoView.layer.cornerRadius = infoView.frame.size.height / 11
        
        empNameLabel.text = EmployeesVC.empIDHolder.employeeName
        
        loadEmpImage()
    }
    
    func loadEmpImage() {
        getEmpData { imageData in
            let image = UIImage(data: imageData.empImageData)
            self.imageView.image = image
        }
    }
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func getEmpDocID(success: @escaping ((String)->Void),  failure: @escaping ((String)->Void)){

        db.collection("employee").whereField("empID", isEqualTo: EmployeesVC.empIDHolder.employeeID).getDocuments {querySnapshot, e in
            if let error = e {
                failure(error.localizedDescription)
            }else{
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        self.documentsIDHolder.empDocumentID = doc.documentID
                        
                        success(self.documentsIDHolder.empDocumentID)
                    }
                }
            }
        }
    }
    
    func getEmpData(success: @escaping ((Employee)->Void))  {
        
        getEmpDocID { empDocID in
            
            self.db.collection("employee").document(empDocID).getDocument { docSnapShot, e in
                
                    if let document = docSnapShot?.data() {
                        let doc = document

                        if let email = doc["email"] as? String,
                           let empImageData = doc["empImageData"] as? Data,
                           let title = doc["title"] as? String,
                           let mobile = doc["mobile"] as? String,
                           let gender = doc["gender"] as? String{
                            
                            
                            let employeeInfo = Employee(empImageData: empImageData, email: email, title: title, mobile: mobile, gender: gender)
                            
                            success(employeeInfo)

                        }
                    }
                }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
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
        
        getEmpDocID { docID in
            self.db.collection("employee").document(docID).setData(["empImageData": imageData], merge: true) { error in
                if let _ = error{
                    self.presentAlertInMainThread(message: "Image size is more than 1 MB.")
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

//MARK: - TableView Delegare & Data Source

extension SelectedEmpProfileVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.infoCellIdentifier, for: indexPath) as! infoCell
        
        cell.titleLabel.text = titles[indexPath.section]
        cell.textField.delegate = self
        
        getEmpData { empData in

            switch indexPath.section {
            case 0:
                cell.textField.text = empData.title
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
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4{
            return 30
        }else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}
//MARK: - TextField Delegate

extension SelectedEmpProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}


