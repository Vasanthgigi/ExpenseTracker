//
//  CreateExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-13.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class CreateExpenseViewController: BaseViewController {

    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var amountTextField: UITextField!
    @IBOutlet weak private var categoriesTextField: UITextField!
    @IBOutlet weak private var notesTextView: UITextView!
    @IBOutlet weak private var errorLabel: UILabel!

    private let emptyFieldsString = "One or more fields are empty"
    private let userExistString = "Error creating expense"
     
    var reloadExpensesClosure: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        reloadExpensesClosure = nil
    }
}

private extension CreateExpenseViewController {
    
    @IBAction func submitAction(_ sender: UIButton) {
                
        var categoryArray = [Category]()
        let categoriesString = categoriesTextField.text!.components(separatedBy: ",")
        for categoryString in categoriesString {
            let category = Category(ID: nil, name: categoryString, expenseID: nil)
            categoryArray.append(category)
        }
        
        let expense = Expenses(ID: nil, title: titleTextField.text, amount: Double(amountTextField.text!), categories: categoryArray, date: Date(), notes: notesTextView.text, userID: User.shared.id)
        
        if expense.validateModel() {
            let isAdded = DBHelper.shared.insertIntoExpenses(expenses: expense)
            if isAdded {
                reloadExpensesClosure?()
                navigationController?.popViewController(animated: true)
            } else {
                errorLabel.isHidden = false
                errorLabel.text = userExistString
            }
        } else {
            errorLabel.isHidden = false
            errorLabel.text = emptyFieldsString
        }
    }
}
