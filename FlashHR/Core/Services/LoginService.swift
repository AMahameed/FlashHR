//
//  LoginService.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import Foundation
import Firebase
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
    
    func performForgetPassword(_ email: String, success: @escaping(()->(Void)), failure: @escaping((String)->(Void)) ) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let e = error{
                failure(e.localizedDescription)
            }else {
                success()
            }
        }
    }
}
