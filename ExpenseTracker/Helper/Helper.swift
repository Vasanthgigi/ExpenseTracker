//
//  Helper.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit
import CryptoKit

class Helper: NSObject {
    
    class func isValidEmail(emailString: String?) -> Bool {
        if let emailStr  = emailString {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return email.evaluate(with: emailStr)
        }
        return false
    }
    
    class func validateArray(array: [AnyObject]?) -> Bool {
        if array != nil && (array?.count)! > 0 {
            return true
        }
        return false
    }
    
    class func validateString(string: String?) -> Bool {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedString.isEmpty {
                return true
            }
        }
        return false
    }
}

extension String {
    func sha256() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let digest = SHA256.hash(data: data)
        return digest.hexStr
    }
    
    func getCurrentDateUTCString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)!
        return date
    }
}

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
    
    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

extension Date {
    func getCurrentTimeUTCString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func getLocalTimeFromUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let datetring = dateFormatter.string(from: self)
        return datetring
    }
    
    func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    func pastWeek() -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
    }
    
    func pastMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
