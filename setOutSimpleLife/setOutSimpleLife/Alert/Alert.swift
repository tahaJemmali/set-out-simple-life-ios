//
//  Alert.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/20/20.
//

import Foundation
import UIKit

struct Alert {
    private static func showBasicAlert (on vc: UIViewController,with title: String, message: String){
        let Alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //DispatchQueue.main.async {
            vc.present(Alert, animated: true) 
        //}
    }
    static func showIncompleteFormAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Incomplete Form", message: "Please fill out all fields in the form")
    }
    
    static func showInvalidEmailAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid Email", message: "Please use a valid email")
    }
    
    static func showInvalidFirstNameAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid first name", message: "Please use a valid first name")
    }
    
    static func showInvalidLastNameAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid last name", message: "Please use a valid last name")
    }
    
    static func showInvalidPhoneAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid phone number", message: "Please use a valid phone number")
    }
    
    static func showInvalidAddressAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid address", message: "Please use a valid home town")
    }
    
    static func showInvalidPasswordAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Invalid password ", message: "Incorrect password")
    }
    
    static func showCustomAlert(on vc: UIViewController,title:String,msg:String){
        showBasicAlert(on: vc, with: title, message: msg)
    }
}
