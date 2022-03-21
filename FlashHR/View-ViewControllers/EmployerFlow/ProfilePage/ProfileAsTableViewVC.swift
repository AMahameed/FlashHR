//
//  ProfileAsTableViewVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/20/22.
//

import UIKit

class ProfileAsTableViewVC: UIViewController {
    
    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var titles = ["Company Name","Email","Mobile No.","Gender"]
//    var placeHolder = ["Name","Company Name","Email","Mobile No.","Gender"]
    var text = ["Zain Jo","A.Mahameed2000@gmail.com","0796957821","Male"]
    
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "infoCell", bundle: nil) , forCellReuseIdentifier: "infoCell")
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.05
        infoView.layer.cornerRadius = infoView.frame.size.height / 11
    }
    
    func performSwitch(_ indexPath: IndexPath) -> infoCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"infoCell", for: indexPath) as! infoCell
        cell.titleLabel.text = titles[indexPath.section]
//        cell.textField.placeholder = placeHolder[indexPath.section]
        cell.textField.text = text[indexPath.section]
        return cell
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        loginService.performLogout {
            self.presentFromSTB(stbName: "Login", vcID: "Login")
        } failure: { signOutError in
            self.presentAlert(message: signOutError)
        }
        
    }
}

extension ProfileAsTableViewVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section {
        case 0:
            let cell = performSwitch(indexPath)
            return cell
        case 1:
            let cell = performSwitch(indexPath)
            return cell
        case 2:
            let cell = performSwitch(indexPath)
            return cell
        case 3:
            let cell = performSwitch(indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4{
            return 40
        }else{
            return 25
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
