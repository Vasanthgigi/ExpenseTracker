//
//  DBHelper+Category.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-13.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit
import SQLite3

extension DBHelper {
    
    func createCategoryTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS category(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, expenseID INTEGER, FOREIGN KEY (expenseID) REFERENCES expenses (Id));"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("category table created.")
            } else {
                print("category table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertIntoCategory(category: Category) -> Bool {
        let insertStatementString = "INSERT INTO category (name, expenseID) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (category.name!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(category.expenseID!))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
                return false
            }
        } else {
            print("INSERT statement could not be prepared.")
            return false
        }
        sqlite3_finalize(insertStatement)
        return true
    }
    
    func selectFromCategory(expenseID: Int) -> [Category] {
        let queryStatementString = "SELECT * FROM category WHERE expenseID = '\(expenseID)';"
        var queryStatement: OpaquePointer? = nil
        var users : [Category] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let expenseID = sqlite3_column_int(queryStatement, 2)

                let category = Category(ID: Int(id), name: name, expenseID: Int(expenseID))
                users.append(category)
                print("Query Result:")
                print("\(id) | \(name) | \(expenseID)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func dropCategory() {
        let createTableString = "DROP TABLE IF EXISTS category;"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("category table deleted.")
            } else {
                print("category table could not be deleted.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
}
