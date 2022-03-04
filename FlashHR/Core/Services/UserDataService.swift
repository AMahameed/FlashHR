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
    static var flag = true
    
    var isFirstLogin: Bool {
        if Constants.UserDataDefault.currentUserID == nil && UserDataService.flag{
            return true
        }else{
            return false
        }
    }
    
    var isEmployeer: Bool {
        return self.userID == Constants.Strings.employerID
    }
    
    var userID: String? {
        return Constants.UserDataDefault.currentUserID
    }
}
