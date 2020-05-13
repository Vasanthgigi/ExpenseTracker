//
//  ExistingViewController.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class ExistingViewController: BaseViewController {

    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passcodeTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var users: [User] = []
    
    private let emptyFieldsString = "Empty field or invalid email"
    private let incorrectEmailString = "Incorrect email or passcode"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        users.removeAll()
    }
}

private extension ExistingViewController {
    
    @IBAction func submitAction(_ sender: UIButton) {
                
        let user = User(id: nil, name: nil, email: emailTextField.text, passcode: passcodeTextField.text!.sha256())
        
        if !user.validateModelForSignIn() {
            errorLabel.text = emptyFieldsString
            errorLabel.isHidden = false
            return
        }
        
        let existingUser = DBHelper.shared.getUser(user: user)
        if existingUser != nil {
            existingUser?.convertModelToSingleton()
            errorLabel.isHidden = true
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let expensesViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.ExpensesViewControllerID) as! ExpensesViewController
            self.navigationController?.pushViewController(expensesViewController, animated: true)
        } else {
            errorLabel.isHidden = false
            errorLabel.text = incorrectEmailString
        }
    }
}

