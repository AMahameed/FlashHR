//
//  FireBaseService.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 4/26/22.
//

import Foundation
import Firebase

class FireBaseService: UIViewController{
    
    private let db = Firestore.firestore()
    
    func getEmpDocID(empID: String ,success: @escaping ((String)->Void),  failure: @escaping ((String)->Void)){

        db.collection("employee").whereField("empID", isEqualTo: empID).getDocuments {querySnapshot, e in
            if let error = e {
                failure(error.localizedDescription)
            }else{
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        success(doc.documentID)
                    }
                }
            }
        }
    }
    
    
    func getEmpData(empID: String, success: @escaping ((Employee)->Void))  {
        
        getEmpDocID(empID: empID){ [weak self] empDocID in
            
            self?.db.collection("employee").document(empDocID).getDocument { docSnapShot, e in
                
                if let document = docSnapShot?.data() {
                    let doc = document
                    
                    if let email = doc["email"] as? String,
                       let userName = doc["userName"] as? String,
                       let empImageData = doc["empImageData"] as? Data,
                       let title = doc["title"] as? String,
                       let mobile = doc["mobile"] as? String,
                       let gender = doc["gender"] as? String{
                        
                        
                        let employeeInfo = Employee(empImageData: empImageData, email: email, userName: userName, title: title, mobile: mobile, gender: gender)
                        
                        success(employeeInfo)
                        
                    }
                }
            }
        } failure: { error in
            self.presentAlertInMainThread(message: error)
        }
    }
}
