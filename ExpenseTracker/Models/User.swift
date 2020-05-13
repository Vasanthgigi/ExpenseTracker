//
//  User.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    public var id: Int?
    public var name: String?
    public var email: String?
    public var passcode: String?
    
    static let shared = User()

    override init() {
        super.init()
    }
    
    init(id: Int?, name: String?, email: String?, passcode: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.passcode = passcode
    }
    
    func validateModelForSignUp() -> Bool {
        var isValid = true
        if !Helper.validateString(string: name) || !Helper.isValidEmail(emailString: email) || !Helper.validateString(string: passcode) {
            isValid = false
        }
        return isValid 
    }
    
    func validateModelForSignIn() -> Bool {
        var isValid = true
        if !Helper.isValidEmail(emailString: email) || !Helper.validateString(string: passcode) {
            isValid = false
        }
        return isValid
    }
    
    func convertModelToSingleton() {
        User.shared.id = self.id
        User.shared.name = self.name
        User.shared.email = self.email
        User.shared.passcode = self.passcode
    }
}
