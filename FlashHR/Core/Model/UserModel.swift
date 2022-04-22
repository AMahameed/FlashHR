//
//  UserModel.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.


import Foundation


struct Employer {
    let employerID: String = "Afej9lwEGmZspb1ZXx89o45sVcs2"
    let message: Message
    let employee: Employee
}

class Employee {
    var empID: String = ""
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var title: String = ""
    var mobile: String = ""
    var gender: String = ""
    var isDeleted: Bool = false
    var isEmployer: Bool = false
    var workTransactions: [WorkTansactions] = []
    
    init(empID: String = "", email: String = "", password: String = "", userName: String = "", title: String = "", mobile: String = "", gender: String = "") {
        self.empID = empID
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
    var dayNo: Int = 0
    var date: Date = Date()
    var workingHours: Int = 0
    var long: Float = 0.0
    var lat: Float = 0.0
    var isRequestedLeave: Bool = false
    var leaveHours: Float = 0.0
}

struct TansactionsHolder {
    var projectName: String = ""
    var contactNo: String = ""
    var startTime: String = ""
    var dayNo: Int = 0
    var date: Date = Date()
    var workingHours: Int = 0
    var long: Float = 0.0
    var lat: Float = 0.0
    var isRequestedLeave: Bool = false
    var leaveHours: Float = 0.0
}

struct DocumentsIDHolder {
    var empDocumentID: String = ""
    var workTransactionsDocumentID : String = ""
}

struct Message {
    let sender: String
    let body: String
    let date: Date
}
