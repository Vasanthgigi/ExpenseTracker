//
//  Category.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-13.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class Category: NSObject {

    public var ID: Int?
    public var name: String?
    public var expenseID: Int?
    
    init(ID: Int?, name: String?, expenseID: Int?) {
        self.ID = ID
        self.name = name
        self.expenseID = expenseID
    }
}
