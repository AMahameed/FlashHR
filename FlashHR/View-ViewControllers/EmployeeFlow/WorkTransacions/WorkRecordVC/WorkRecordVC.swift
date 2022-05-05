//
//  WorkRecordVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/5/22.
//

import UIKit

class WorkRecordVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    private var titles = [ "Project Name", "Contact Number", "Start Time", "Working Hours", "Requested Leave"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.workDetailsCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.workDetailsCellIdentifier)
        
        backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 11
        welcomeLabel.text = "Hey, here is your Work Details."
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}


//MARK: - TableView Delegate and Data Source

extension WorkRecordVC: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.workDetailsCellIdentifier, for: indexPath) as? WorkDetailsCell else {return UITableViewCell()}
        
        cell.textField.isUserInteractionEnabled = false
        
        if let WT = WorkTranacitonsVC.oldWTItem{
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
        case 4:
            cell.titleLabel.text = titles[indexPath.row]
            cell.textField.text = String(WT.isRequestedLeave)
        default:
            break
        }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
