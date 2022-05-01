//
//  UserModel.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.


import Foundation

class Employee {
    var empID: String = ""
    var empImageData: Data = Data()
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var title: String = ""
    var mobile: String = ""
    var gender: String = ""
    var isDeleted: Bool = false
    var isEmployer: Bool = false
    var workTransactions: [WorkTansactions] = []
    
    init(empID: String = "", empImageData: Data = Data(), email: String = "", password: String = "", userName: String = "", title: String = "", mobile: String = "", gender: String = "") {
        self.empID = empID
        self.empImageData = empImageData
        self.userName = userName
        self.mobile = mobile
        self.gender = gender
        self.title = title
        self.password = password
        self.email = email
    }
}

struct WorkTansactions {
    var projectName: String = ""
    var contactNo: String = ""
    var startTime: String = ""
    var dayStr: String = ""
    var workingHours: Int = 0
    var long: Double = 0.0
    var lat: Double = 0.0
    var isRequestedLeave: Bool = false
    var leaveHours: Float = 0.0
}

struct TransactionsHolder {
    var projectName: String = ""
    var contactNo: String = ""
    var startTime: String = ""
    var dayStr: String = ""
    var workingHours: Int = 0
    var long: Double = 0.0
    var lat: Double = 0.0
    var isRequestedLeave: Bool = false
    var leaveHours: Float = 0.0
}

struct Message {
    var sender: String = ""
    var body: String = ""
    var date: Date = Date()
}
