//
//  WorkDetailsCell.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit

class WorkDetailsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    private var genderPickerView = UIPickerView()
    private var genderTypes = ["Male","Female"]
    var genderTypeHandler: ((String)->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textField.isSecureTextEntry = false
        textField.keyboardType = .default
        textField.inputView = nil
    }
    
    
    
    func populateCreateEmpCell(with field: String, info: String?, index: Int, genderHandler: ((String)->())? = nil){
        titleLabel.text = field
        textField.text = info ?? ""
        self.genderTypeHandler = genderHandler
        switch index {
        case 1:
            textField.isSecureTextEntry = true
        case 4:
            textField.keyboardType = .numberPad
        case 5:
            textField.inputView = self.genderPickerView
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - PickerView

extension WorkDetailsCell: UIPickerViewDelegate, UIPickerViewDataSource{

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
        let gender = genderTypes[row]
        textField.text = gender
        genderTypeHandler?(gender)
    }
}
