//
//  CommmunicationVC.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit
import Firebase

class CommmunicationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewUnderneathText: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    let fireBaseService = FireBaseService()
    let db = Firestore.firestore()
    var messages: [Message] = []
    var docID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUnderneathText.layer.cornerRadius = viewUnderneathText.frame.size.height / 5
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 5
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.messgaeCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.messgaeCellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {

        fireBaseService.getEmpDocID(empID: Constants.Strings.employerID) { empDocID in
            self.docID = empDocID
            self.db.collection("employee").document(empDocID).collection("messages").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
                
                self.messages.removeAll()
                
                if let error = error {
                    self.presentAlertInMainThread(message: error.localizedDescription)
                } else{
                    self.messages.removeAll()
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data["sender"] as? String,
                               let body = data["body"] as? String{
                                
                                let newMessage = Message(sender: sender, body: body)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard !textView.text.isEmpty else {presentAlert(title: "Warning", message: "Fill the Text field.", preferredStyle: .alert ); return}
        
        if let messageBody = self.textView.text {
            self.db.collection("employee").document(self.docID).collection("messages").addDocument(data: [
                "sender": Constants.Strings.employerName,
                "body": messageBody,
                "date": Date().timeIntervalSince1970]){ error in
                    
                    if let error = error {
                        self.presentAlertInMainThread(message: error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        self.textView.text = ""
                    }
                }
        }
    }
    
    func getMessageID(indexPathForRowAT indexPath: IndexPath, success: @escaping (String) -> Void ) {
        
        db.collection("employee").document(docID).collection("messages").whereField("body", isEqualTo: messages[indexPath.row].body).addSnapshotListener { querysnapShot, error in
            if let error = error{
                print(error.localizedDescription)
            }
            if let documents = querysnapShot?.documents{
                for doc in documents{
                    success(doc.documentID)
                }
            }
        }
    }
    
    private func deleteAction(rowIndexPathAT indexPath: IndexPath) -> UIContextualAction {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to proceed ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.getMessageID(indexPathForRowAT: indexPath) { messageID in
                    self.db.collection("employee").document(self.docID).collection("messages").document(messageID).delete()
                }
            }))
            self.present(alert,animated: true)
        }
        return deleteAction
    }
    
}

//MARK: - TableView Delegate and DataSource

extension CommmunicationVC: UITableViewDataSource, UITableViewDelegate{
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteAction(rowIndexPathAT: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
}
