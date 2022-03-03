//
//  UserData.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.
//

import Foundation

class UserDataService {
    static let shared = UserDataService()
    var isFirstLogin: Bool = true
    var isEmployeer: Bool {
        return self.userID == Constants.Strings.employerID
    }
    
    var userID: String? {
        return Constants.UserDataDefault.currentUserID
    }
}
