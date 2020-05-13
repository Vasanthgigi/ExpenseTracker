//
//  Expenses.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class Expenses: NSObject {

    public var ID: Int?
    public var title: String?
    public var amount: Double?
    public var categories: [Category]?
    public var dateAdded: Date
    public var notes: String?
    public var userID: Int?
    
    init(ID: Int?, title: String?, amount: Double?, categories: [Category]?, date: Date, notes: String?, userID: Int?) {
        self.ID = ID
        self.title = title
        self.amount = amount
        self.categories = categories
        self.dateAdded = date
        self.notes = notes
        self.userID = userID
    }
    
    func validateModel() -> Bool {
        var isValid = true
        if !Helper.validateString(string: title) || amount == nil || amount! <= 0 || !Helper.validateArray(array: categories) {
            isValid = false
        }
        return isValid
    }
    
    func getCategoryNames() -> String {
        var categoryString = ""
        if Helper.validateArray(array: categories) {
            for category in categories! {
                categoryString += category.name! + " "
            }
            return categoryString
        }
        return categoryString
    }
}
