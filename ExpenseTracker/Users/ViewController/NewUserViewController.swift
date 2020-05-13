//
//  NewUserViewController.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class NewUserViewController: BaseViewController {
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passcodeTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var users: [User] = []
    
    private let emptyFieldsString = "One or more fields are empty"
    private let userExistString = "User already exist try using differnt email"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        users.removeAll()
    }
}

private extension NewUserViewController {
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        let user = User(id: nil, name: nameTextField.text, email: emailTextField.text, passcode: passcodeTextField.text!.sha256())
        
        if !user.validateModelForSignUp() {
            errorLabel.text = emptyFieldsString
            errorLabel.isHidden = false
            return
        }
        
        let isInserted = DBHelper.shared.insertIntoUser(user: user)
        if isInserted {
            let existingUser = DBHelper.shared.getUser(user: user)
            existingUser?.convertModelToSingleton()

            errorLabel.isHidden = true
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let expensesViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.ExpensesViewControllerID) as! ExpensesViewController
            self.navigationController?.pushViewController(expensesViewController, animated: true)
        } else {
            errorLabel.isHidden = false
            errorLabel.text = userExistString
        }
    }
}
