//
//  AvaliableWorkVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/5/22.
//
 
import UIKit

class AvaliableWorkVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    private let helperService = HelperServices()
    private var titles = [ "Project Name", "Contact Number", "Assigned Start Time", "Working Hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        tableView.register(UINib(nibName: "WorkLocationCell", bundle: nil), forCellReuseIdentifier: "workLocationCell")
        tableView.register(UINib(nibName: "StartEndShiftCell", bundle: nil), forCellReuseIdentifier: "startEndShiftCell")
        
        backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 11
        welcomeLabel.attributedText = helperService.partialBoldString(WorkTranacitonsVC.newWTItem!.dayStr, "Hey, here's your Work Details on ")
        
    }
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - TableView Delegate and Data Source

extension AvaliableWorkVC: UITableViewDataSource, UITableViewDelegate, StartEndShiftCellDelegate{
    
    func proceedEndingSHift(_ complition: @escaping (Bool) -> ()) {
        let alert = UIAlertController(title: "Warning", message: "Beware, When you choose to End Shift it means that your actual working hours are counted from the moment you pressed Start Shift till the moment you Press End Shift only.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            complition(false)
        }))
        alert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { _ in
            complition(true)
        }))
        present(alert,animated: true)
    }
    
    func failOrSuccess(tag: Int8) {
        switch tag {
        case 1:
            presentAlert(title: "Well Done", message: "You've started your Shift Successfully.")
        case 2:
            presentAlert(message: "You can't Start Shift, While being out of work site Location", preferredStyle: .alert)
        case 3:
            presentAlert(message: "You can't Start Shift, the assined Job is not for today", preferredStyle: .alert)
        case 4:
            presentAlert(title: "Well Done", message: "You've Ended your Shift Successfully.")
        case 5:
            presentAlert(message: "You can't End Shift, While being out of work site Location", preferredStyle: .alert)
        case 7:
            presentAlert(message: "Error in retrieving your Data!", preferredStyle: .alert)
        case 8:
            presentAlert(message:"Error in retrieving your Work Transactions!", preferredStyle: .alert)
        case 9:
            presentAlert(message: "coudn't retrieve if the selected day is Worked!", preferredStyle: .alert)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell,
              let locationCell = tableView.dequeueReusableCell(withIdentifier: "workLocationCell", for: indexPath) as? WorkLocationCell,
              let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "startEndShiftCell", for: indexPath) as? StartEndShiftCell
         else {return UITableViewCell()}
        
        cell.textField.isUserInteractionEnabled = false
        
        if indexPath.row <= 3{
            if let WT = WorkTranacitonsVC.newWTItem{
                switch indexPath.row {
                case 0:
                    cell.titleLabel.text = titles[indexPath.row]
                    cell.textField.text = WT.projectName
                case 1:
                    cell.titleLabel.text = titles[indexPath.row]
                    cell.textField.text = WT.contactNo
                case 2:
                    cell.titleLabel.text = titles[indexPath.row]
                    cell.textField.text = WT.startTime
                case 3:
                    cell.titleLabel.text = titles[indexPath.row]
                    cell.textField.text = String(WT.workingHours)
                default:
                    break
                }
            }
        }
        
        switch indexPath.row {
        case 4:
            return locationCell
        case 5:
            buttonsCell.delegate = self
            return buttonsCell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
