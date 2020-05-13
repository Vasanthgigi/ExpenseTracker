//
//  ExpensesTableViewCell.swift
//  ExpenseTracker
//
//  Created by Vasanth Rathnakumar on 2020-05-13.
//  Copyright © 2020 Vasanth Rathnakumar. All rights reserved.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var notesLabel: UILabel!

    var expense: Expenses? {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

private extension ExpensesTableViewCell {
    
    func setup() {
        titleLabel.text = expense?.title
        amountLabel.text = "\((expense?.amount)!)"
        dateLabel.text = expense?.dateAdded.getLocalTimeFromUTC()
        categoryLabel.text = expense?.getCategoryNames()
        notesLabel.text = expense?.notes
    }
}
