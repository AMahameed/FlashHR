//
//  CommmunicationVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit

class CommmunicationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewUnderneathText: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    let message = "In many geographic areas mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUnderneathText.layer.cornerRadius = viewUnderneathText.frame.size.height / 5
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "messageCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.estimatedRowHeight =  600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
}

extension CommmunicationVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.bodyLabel.text = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
