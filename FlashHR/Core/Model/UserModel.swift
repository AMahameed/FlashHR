//
//  UserModel.swift
//  FlashHR
//
//  Created by Abdallah Mahameed on 3/3/22.


import Foundation


struct UserModel {
    let email: String
    let userName: String = "Employee Name"
    let mobile: String = "0700000000"
    let isDeleted: Bool = false
    let isEmployer: Bool = false
    let isFirstTimeLogin: Bool = false
    let workTransactions: [WorkTansactions]
}

struct WorkTansactions {
    let id: String
    let date: Date
    let hours: Float
    let isRequestedLeave: Bool = false
    let leaveHours: Float
}

