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
    var titles = ["Company Name","Title","Email","Mobile No.","Gender"]
    var text = ["Zain Jo","Senior Developer","A.Mahameed2000@gmail.com","0796957821","Male"]
    
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.infoCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.infoCellIdentifier)
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.05
        infoView.layer.cornerRadius = infoView.frame.size.height / 11
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        loginService.performLogout {
            self.presentFromSTB(stbName: Constants.Segues.LoginSegue, vcID: Constants.Segues.LoginSegue)
        } failure: { signOutError in
            self.presentAlertInMainThread(message: signOutError)
        }
    }
}

//MARK: - TableView Delegate
extension ProfileAsTableViewVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.infoCellIdentifier, for: indexPath) as! infoCell
        
        cell.titleLabel.text = titles[indexPath.section]
        cell.textField.text = text[indexPath.section]
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
