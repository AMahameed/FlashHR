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
    let message = "In many geographic areas, mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America was the Advanced Mobile Phone System (AMPS) GSM uses a combination of TDMA and frequency division multiple access (FDMA)"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUnderneathText.layer.cornerRadius = viewUnderneathText.frame.size.height / 5
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "messageCell")
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
    
}
