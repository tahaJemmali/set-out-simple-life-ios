//
//  BirthDatePopUpViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/16/20.
//

import UIKit

class BirthDatePopUpViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: myProtocol?
    
    @IBAction func saveBtn(_ sender: Any) {
        dismiss(animated: true)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        UserModel.shared.birth_date = datePicker.date as NSDate
        
        delegate?.doAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
    }

}
