//
//  EmpCommmunicationVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 5/3/22.
//

import UIKit
import FirebaseFirestore

class EmpCommmunicationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let fireBaseService = FireBaseService()
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.messgaeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.messgaeCellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {

        fireBaseService.getEmpDocID(empID: Constants.Strings.employerID) { [weak self] empDocID in
            
            self?.db.collection("employee").document(empDocID).collection("messages").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
                
                self?.messages.removeAll()
                
                if let error = error {
                    self?.presentAlertInMainThread(message: error.localizedDescription)
                } else{
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data["sender"] as? String,
                               let body = data["body"] as? String{
                                
                                let newMessage = Message(sender: sender, body: body)
                                self?.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
}


extension EmpCommmunicationVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.messgaeCellIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}
        
        guard !messages.isEmpty else{return UITableViewCell()}
        
        cell.senderLabel.text = messages[indexPath.row].sender
        cell.bodyLabel.text = messages[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
