//
//  DBHelper+User.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit
import SQLite3

extension DBHelper {
    
    func createUserTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT, passcode TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertIntoUser(user: User) -> Bool {
        let users = selectFromUser()
        for u in users
        {
            if u.email == user.email
            {
                return false
            }
        }
        let insertStatementString = "INSERT INTO user (name, email, passcode) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (user.name!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (user.email!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (user.passcode! as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        return true
    }
    
    func selectFromUser() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let passcode = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                let user = User(id: Int(id), name: name, email: email, passcode: passcode)
                
                users.append(user)
                print("Query Result:")
                print("\(name) | \(email) | \(passcode)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func getUser(user: User) -> User? {
        
        let queryStatementString = "SELECT * FROM user WHERE email = '\(user.email!.lowercased())' AND '\(user.passcode!)';"
        var queryStatement: OpaquePointer? = nil
        var userModel: User?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let passcode = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                userModel = User(id: Int(id), name: name, email: email, passcode: passcode)
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
        return userModel
    }
    
    func dropUserTable() {
        let createTableString = "DROP TABLE IF EXISTS user;"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table deleted.")
            } else {
                print("user table could not be deleted.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
}
