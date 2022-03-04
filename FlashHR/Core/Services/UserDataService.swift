//
//  UserData.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

//Singleton

import Foundation

class UserDataService {
    
    static let shared = UserDataService()
    
    var isEmployeer: Bool {
        return self.userID == Constants.Strings.employerID
    }
    
//    var logID: Bool? {
//        return Constants.UserDataDefault.currentUserLogID
//    }
    
    var userID: String? {
        return Constants.UserDataDefault.currentUserID
    }
}
