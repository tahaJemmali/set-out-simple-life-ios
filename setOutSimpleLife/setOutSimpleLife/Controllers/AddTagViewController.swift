//
//  AddTagViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 04/12/2020.
//

import Foundation
import UIKit
import CULColorPicker


class AddTagViewController: UIViewController,ColorPickerViewDelegate {
    func colorPickerWillBeginDragging(_ colorPicker: ColorPickerView) {
        print(colorPicker.selectedColor.toHexString())
    }
    
    func colorPickerDidSelectColor(_ colorPicker: ColorPickerView) {
        print(colorPicker.selectedColor.toHexString())
    }
    
    func colorPickerDidEndDagging(_ colorPicker: ColorPickerView) {
        print(colorPicker.selectedColor.toHexString())
    }
    
    
    @IBOutlet weak var colorPicker: ColorPickerView!
    @IBOutlet weak var tagName: UITextField!

    override func viewDidLoad() {
    super.viewDidLoad()
           }
    
    @IBAction func addTag(_ sender: Any) {
        
        if !tagName.text!.isEmpty{
            addTag(name: tagName.text!,color: colorPicker.selectedColor.toHexString())
        }else{
              let alert = UIAlertController(title: "Validation error", message: " EROOR: \n tag name must not be empty ", preferredStyle: UIAlertController.Style.alert)
                     alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func addTag(name:String,color:String)  {
        let urlString = "https://set-out.herokuapp.com/add_tag"
       let url = URL(string:urlString)!
           var request = URLRequest(url: url)
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.httpMethod = "POST"
           let parameters: [String: Any] = [
               "tagName": name,
               "color": color
           ]
           request.httpBody = parameters.percentEncoded()

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data,
                   let response = response as? HTTPURLResponse,
                   error == nil else {                                              // check for fundamental networking error
                   print("error", error ?? "Unknown error")
                   return
               }

               guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                   print("statusCode should be 2xx, but is \(response.statusCode)")
                   print("response = \(response)")
                   return
               }

               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(responseString)")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.showToast(message: "Tag added successfully !", font: .systemFont(ofSize: 12.0))
                               }
          
           }

           task.resume()
    }
    }
   
    



