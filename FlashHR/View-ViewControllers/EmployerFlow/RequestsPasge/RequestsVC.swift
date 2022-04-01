//
//  RequestsVS.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/7/22.
//

import UIKit

class RequestsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.NibNames.requestCell, bundle: nil) , forCellReuseIdentifier: Constants.Identifiers.requestCellIdentifier)
      
    }

}

extension RequestsVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.requestCellIdentifier, for: indexPath) as! RequestCell
        
        return cell
    }
    
    
    
    
}
