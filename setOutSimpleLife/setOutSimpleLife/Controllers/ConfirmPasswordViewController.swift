//
//  ConfirmPasswordViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/25/20.
//

import UIKit
import SVProgressHUD

class ConfirmPasswordViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var email:String?

    @IBAction func nextButtonAction(_ sender: Any) {
    
        if (!passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty && passwordTextField.text! == confirmPasswordTextField.text!){
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            resetPassword(email:email!,password:passwordTextField.text!)
            //Alert.showCustomAlert(on: self, title: "Done!", msg: "Password has been reset")
        }else{
            Alert.showInvalidPasswordAlert(on: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    

    func initUI() {
        assignbackground()
        containerView.layer.cornerRadius=15.0
        confirmButton.layer.cornerRadius = 20.0
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true

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
    
    func resetPassword(email:String,password:String) {
        var json: String?
//        var infos:(email: String, code: String)?
//        var stringCode : String?
//        var stringEmail : String?

        //print("email : ",email)
        let parameters: [String: String] = ["email": email,"password":password]
            //create the url with URL
            let url = URL(string: globalUrl + "passwordReset")!
            //let url = URL(string: "https://set-out.herokuapp.com/passwordRecovery")!
            //create the session object
            let session = URLSession.shared
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "PUT" //set http method as PUT
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    return
                }
                
                do {
                    json = String(data: data!,encoding: .utf8)
                    //print("data : ",json!)
                    
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if (json!.contains("Password has been reset")){

                        let alert = UIAlertController(title: "Done!", message: "Password has been reset", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }
                    else if (json!.contains("Error")){
                        Alert.showCustomAlert(on: self.self, title: "Error", msg: "Error has accured")
                    }
                }
            })
            task.resume()
    }

}
