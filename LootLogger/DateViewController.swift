//
//  DateViewController.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 21/02/2021.
//

import UIKit

class DateViewController: UIViewController {

    var date: Date!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.date = date
    }

    public func getSelectedDate() -> Date {
        return datePicker.date
    }
    
}
