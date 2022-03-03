//
//  Constants.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 2/28/22.
//

import UIKit

struct Constants {
    
    struct Strings {
        static var logo = "FlashHR"
        static var employerID = "Afej9lwEGmZspb1ZXx89o45sVcs2"
    }
    
    struct Colors {
        static var spaceColor = "space"
        static var coldColor = "cold"
        static var blueColor = "blue"
        static var navyColor = "navy"
    }
    
    struct Segues{
        static var employerSegue = "ToEmployer"
        static var employeeSegue = "ToEmployee"
        static var firstTimeLoginSegue = "ToFirstTimeLogin"
        static var resetPassSegue = "ToResetPass"
    }
    
    struct UserDefaultKeys {
        static var currentUserIDKey: String = "currentUserIDKey"
    }
    
    struct UserDataDefault {
        static var currentUserID: String? {
            get { return UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.currentUserIDKey) }
            set { UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultKeys.currentUserIDKey) }
        }
    }
}
