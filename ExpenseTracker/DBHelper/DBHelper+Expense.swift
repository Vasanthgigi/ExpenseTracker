//
//  DBHelper+Expense.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit
import SQLite3

extension DBHelper {
    
    func createExpensesTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS expenses(Id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT, note TEXT NULL, userID INTEGER, FOREIGN KEY (userID) REFERENCES user (Id));"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("expenses table created.")
            } else {
                print("expenses table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertIntoExpenses(expenses: Expenses) -> Bool {
        
        let insertStatementString = "INSERT INTO expenses (title, amount, date, note, userID) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (expenses.title!.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 2, expenses.amount!)
            sqlite3_bind_text(insertStatement, 3, ((expenses.dateAdded.getCurrentTimeUTCString()) as NSString).utf8String, -1, nil)
            if let note = expenses.notes {
                sqlite3_bind_text(insertStatement, 4, note.trimmingCharacters(in: .whitespacesAndNewlines), -1, nil)
            }
            sqlite3_bind_int(insertStatement, 5, Int32(expenses.userID!))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                
                if Helper.validateArray(array: expenses.categories) {
                    let expensesArray = selectFromExpenses()
                    let lastAddedExpense = expensesArray[expensesArray.count-1]
                    for category in expenses.categories! {
                        category.expenseID = lastAddedExpense.ID
                        _ = DBHelper.shared.insertIntoCategory(category: category)
                    }
                }
                
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
            return false
        }
        sqlite3_finalize(insertStatement)
        return true
    }
    
    func selectFromExpenses() -> [Expenses] {
        let queryStatementString = "SELECT * FROM expenses WHERE userID = '\(User.shared.id!)';"
        var queryStatement: OpaquePointer? = nil
        var expenses : [Expenses] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let amount = sqlite3_column_double(queryStatement, 2)
                let dateAdded = String(describing: String(cString: sqlite3_column_text(queryStatement, 3))).getCurrentDateUTCString()
                var notesString: String? = nil
                if sqlite3_column_text(queryStatement, 4) != nil {
                    notesString = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                }
                let userID = sqlite3_column_int(queryStatement, 5)
                
                let categories = selectFromCategory(expenseID: Int(id))

                let expense = Expenses(ID: Int(id), title: title, amount: amount, categories: categories, date: dateAdded, notes: notesString, userID: Int(userID))
                expenses.append(expense)
                print("Query Result:")
                print("\(title) | \(amount) | \(dateAdded)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return expenses
    }
    
    func dropExpensesTable() {
        let createTableString = "DROP TABLE IF EXISTS expenses;"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("expenses table deleted.")
            } else {
                print("expenses table could not be deleted.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
}
