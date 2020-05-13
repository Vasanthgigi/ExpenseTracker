//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit
import SQLite3

class UserTypeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        DBHelper.shared.dropCategory()
//        DBHelper.shared.dropUserTable()
//        DBHelper.shared.dropExpensesTable()
        
        DBHelper.shared.createUserTable()
    }
}

private extension UserTypeViewController {
    
    @IBAction func newUserAction(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newUserViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.NewUserControllerID) as! NewUserViewController
        self.navigationController?.pushViewController(newUserViewController, animated: true)
    }
    
    @IBAction func existingUserAction(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newUserViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.ExistingUserControllerID) as! ExistingViewController
        self.navigationController?.pushViewController(newUserViewController, animated: true)
    }
}
