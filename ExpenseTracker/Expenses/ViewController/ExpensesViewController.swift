//
//  ExpensesViewController.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-12.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class ExpensesViewController: BaseViewController {

    @IBOutlet weak private var expensesTableView: UITableView!
    @IBOutlet weak private var filterByCategoryTextField: UITextField!

    private var expensesArray: [Expenses] = []
    private var filteredExpensesArray: [Expenses] = []
    private let cellID = "ExpensesTableViewCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createExpensesTable()
        setupTableViewDataSourceDelegate()
        getExpenses()
        customizeNavBar()
      
        // Do any additional setup after loading the view.
    }
    
    deinit {
        expensesArray.removeAll()
        filteredExpensesArray.removeAll()
    }
}

private extension ExpensesViewController {

    func createExpensesTable() {
        DBHelper.shared.createExpensesTable()
        DBHelper.shared.createCategoryTable()
    }
    
    func setupTableViewDataSourceDelegate() {
        expensesTableView.estimatedRowHeight = 92
        expensesTableView.dataSource = self
        expensesTableView.delegate = self
    }
    
    func getExpenses() {
        let expenses = DBHelper.shared.selectFromExpenses()
        if Helper.validateArray(array: expenses) {
            filteredExpensesArray = expenses
            expensesArray = expenses
            expensesTableView.reloadData()
        }
    }
    
    func customizeNavBar() {
        let addExpenseBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addExpense))
        self.navigationItem.rightBarButtonItem  = addExpenseBarButtonItem
    }
    
    @objc func addExpense(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createExpenseViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.CreateExpenseViewControllerID) as! CreateExpenseViewController
        createExpenseViewController.reloadExpensesClosure = { [weak self] in
            self?.getExpenses()
            self?.expensesTableView.reloadData()
        }
        self.navigationController?.pushViewController(createExpenseViewController, animated: true)
    }
    
    @IBAction func filterByOneDayAction(_ sender: UIButton) {
        filteredExpensesArray.removeAll()
        for expense in expensesArray {
            if expense.dateAdded >= Date().yesterday() {
                filteredExpensesArray.append(expense)
            }
        }
        expensesTableView.reloadData()
    }
    
    @IBAction func filterByOneWeekDayAction(_ sender: UIButton) {
        filteredExpensesArray.removeAll()
        for expense in expensesArray {
            if expense.dateAdded >= Date().pastWeek() {
                filteredExpensesArray.append(expense)
            }
        }
        expensesTableView.reloadData()
    }
    
    @IBAction func filterByOneMonthAction(_ sender: UIButton) {
        filteredExpensesArray.removeAll()
        for expense in expensesArray {
            if expense.dateAdded >= Date().pastMonth() {
                filteredExpensesArray.append(expense)
            }
        }
        expensesTableView.reloadData()
    }
    
    @IBAction func filterCategoryAction(_ sender: UIButton) {
        let categoriesStringArray = filterByCategoryTextField.text!.components(separatedBy: ",")
        filteredExpensesArray.removeAll()
        for categoryString in categoriesStringArray {
            for expense in expensesArray {
                if Helper.validateArray(array: expense.categories) {
                    for category in expense.categories! {
                        if category.name?.lowercased() == categoryString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                            filteredExpensesArray.append(expense)
                            break
                        }
                    }
                }
            }
        }
        expensesTableView.reloadData()
    }
    
    @IBAction func resetFilterAction(_ sender: UIButton) {
        filterByCategoryTextField.text = ""
        filteredExpensesArray.removeAll()
        expensesArray.removeAll()
        getExpenses()
    }
}

//MARK: UITableViewDatasource and UITableViewDelegate
extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExpensesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)! as! ExpensesTableViewCell
        cell.expense = filteredExpensesArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
