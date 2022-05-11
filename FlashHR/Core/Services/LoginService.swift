//
//  LoginService.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import Foundation
import FirebaseAuth

class LoginService {
    func performLogin(for email: String, password: String, success: @escaping(()->(Void)), failure: @escaping((String)->(Void))) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                failure(e.localizedDescription)
            } else {
                Constants.UserDataDefault.currentUserID = authResult?.user.uid
                success()
            }
        }
    }
    
    func performLogout(success: @escaping(()->(Void)), failure: @escaping ((String)->(Void))) {
        
        do {
            try Auth.auth().signOut()
            Constants.UserDataDefault.currentUserID = nil
            success()
        } catch let signOutError as NSError {
            failure(signOutError.localizedDescription)
        }
    }
    
    func performForgetPassword(_ email: String, success: @escaping(()->(Void)), failure: @escaping((String)->(Void)) ) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let e = error{
                failure(e.localizedDescription)
            }else {
                success()
            }
        }
    }
    
    func performSignUp(_ employee: Employee, success: @escaping ((Employee)->Void), failure: @escaping ((String)->Void)) {
        Auth.auth().createUser(withEmail: employee.email, password: employee.password) { result, error in
            if let e = error {
                failure(e.localizedDescription)
            }else {
                employee.empID = result?.user.uid ?? ""
                success(employee)
            }
        }
    }
}
