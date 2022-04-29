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
        static var employerName: String = "Abdallah Mahameed"
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
        static var resetPassSegue = "ToResetPass"
        static var LoginSegue = "Login"
        static var createEmployeeSegue = "CreateEmployee"
        static var daysSchedulesSegue = "DaysSchedules"
        static var workDetailsSegue = "WorkDetails"
        static var ProfileOrSchedule = "ProfileOrSchedule"
        static var ProfileAsTableView = "ProfileAsTableView"
        static var SelectedEmpProfile = "SelectedEmpProfile"
    }
    
    struct NibNames {
        static var employeeCell = "EmployeeCell"
        static var workDetailsCell =  "WorkDetailsCell"
        static var messgaeCell =  "MessageCell"
        static var requestCell = "RequestCell"
        static var infoCell = "infoCell"
    }
    
    struct Identifiers {
        static var employeeCellIdentifier = "employeeCell"
        static var workDetailsCellIdentifier = "workDetailsCell"
        static var messgaeCellIdentifier = "messageCell"
        static var requestCellIdentifier = "reusableRequestCell"
        static var infoCellIdentifier = "infoCell"
    }
    
    struct FStore {
    }
    
    struct WorkDetailsVCConstants {
        static var startTime = ["00", "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
        
        static var workingHours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    }
    
    struct CommunicationVCConstants {
        static let message = "In many geographic areas mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America mobile telephones are the only economical way to provide phone service to the population. The dominant first-generation wireless network in North America"
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

