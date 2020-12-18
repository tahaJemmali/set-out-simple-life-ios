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
            addBalance()
        }else{
            let alert = UIAlertController(title: "Validation error", message: " EROOR: \n balance name must not be empty, amount must be a number and you should selecct only one switch (+ or -) ", preferredStyle: UIAlertController.Style.alert)
                      alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
        }
    }
    //VAR
    
    //Function
    func addBalance() {
        var type:String = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if earned.isOn{
            type="EARNED"
        }else{
            type="SPENT"
        }
        let parameters: [String:Any] = [
                "balanceName":name.text!,
                "balanceAmount":Double(amount.text!)!,
                "dateCreation":dateformatter.string(from:datePicker!.date),
                    "type":type
                     ]

        let url = URL(string: "https://set-out.herokuapp.com/add_balance")!
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
               // insert json data to the request
               let headers = [ "Content-Type": "application/json" ]
               request.allHTTPHeaderFields = headers
               request.httpBody = jsonData
            
               print(jsonData!)
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let data = data, error == nil else {
                       print(error?.localizedDescription ?? "No data")
                       return
                   }
                   let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                   if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                       
                       DispatchQueue.main.async {
                        FinanceViewController.instance?.getAllBalances()
                          FinanceViewController.instance?.tableBalances.reloadData()
                                         self.dismiss(animated: true, completion: nil)
                                         self.showToast(message: "Balance added successfully !", font: .systemFont(ofSize: 12.0))
                                                        }
                   }
        }.resume()
    }
    func validator() -> Bool {
        if earned.isOn && spent.isOn{
            return false
        }
        if !earned.isOn && !spent.isOn{
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
