//
//  DaysSchedulesVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/23/22.
//

import UIKit

class DaysSchedulesVC: UIViewController {
    
    @IBOutlet weak var allWeekFill: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var segBar: UISegmentedControl!
    
    var Days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DaysSchedulesCell", bundle: nil) , forCellReuseIdentifier: "daysSchedulesCell")
        
        viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 11
        navigationItem.title = segBar.titleForSegment(at: segBar.selectedSegmentIndex)
    }
    
    @IBAction func SeagmentBarPressed(_ sender: UISegmentedControl) {
        navigationItem.title = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    @IBAction func allWeekPressed(_ sender: UIBarButtonItem) {
        self.presentFromSTB(stbName: "WorkDetails", vcID: "WorkDetails")
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

extension DaysSchedulesVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"daysSchedulesCell", for: indexPath) as! DaysSchedulesCell
        cell.dayLabel.text = Days[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 7 {
            return 30
        }else{
            return 15
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentFromSTB(stbName: "WorkDetails", vcID: "WorkDetails")
    }
}
