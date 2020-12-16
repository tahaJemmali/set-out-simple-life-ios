//
//  ConfirmCodeViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/25/20.
//

import UIKit
import KKPinCodeTextField

class ConfirmCodeViewController: UIViewController {

    
    //var
    var dictSendData:[String] = []


    @IBAction func nextButtonAction(_ sender: Any) {
    //print("code verification"+dictSendData[1])
    //print("text field code"+codeTextField.text!)
        
        ///$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        //codeTextField.text = dictSendData[1]
        ///$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

        if (codeTextField.text!.contains(dictSendData[1])){
            //Alert.showCustomAlert(on: self, title: "", msg: "Reset your password")
            performSegue(withIdentifier: "toResetPasswordSegue", sender: dictSendData[0] )
        }else{
            Alert.showCustomAlert(on: self, title: "Error", msg: "Wrong code")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toResetPasswordSegue"){
        let email = sender as! String
        let destination = segue.destination as! ConfirmPasswordViewController
        destination.email = email
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var codeTextField: KKPinCodeTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    

    func initUI() {
        assignbackground()
        containerView.layer.cornerRadius=15.0
        confirmButton.layer.cornerRadius = 20.0

    }
    

    
    func assignbackground(){
           let background = UIImage(named: "login/LOGIN")
            
            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
       }


}
