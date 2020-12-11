//
//  AddBalanceViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 11/12/2020.
//

import UIKit

class AddBalanceViewController: UIViewController {

    //IBOUTLET
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var earned: UISwitch!
    @IBOutlet weak var spent: UISwitch!
    //IBACTION
    @IBAction func addBalance(_ sender: Any) {
        if validator(){
            
        }else{
            let alert = UIAlertController(title: "Validation error", message: " EROOR: \n balance name must not be empty, amount must be a number and you should selecct only one switch (+ or -) ", preferredStyle: UIAlertController.Style.alert)
                      alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
        }
    }
    //VAR
    
    //Function
    func validator() -> Bool {
        if earned.isOn && spent.isOn{
            return false
        }
        if name.text!.isEmpty{
                   return false
               }
        if amount.text!.isEmpty{
                   return false
               }
        if Double(amount.text!) == nil{
            return false
        }
        return true
    }
    //State
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
