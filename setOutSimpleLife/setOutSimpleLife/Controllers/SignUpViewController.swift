//
//  SignUpViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/19/20.
//


import UIKit
import SVProgressHUD
//import ValidationTextField

class SignUpViewController: UIViewController {

    
    var delegate: myProtocol?

    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    @IBOutlet weak var containerUIView: UIView!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
        
    func initUI() {
        
        assignbackground()
        signupButton.layer.cornerRadius = 20.0
        containerUIView.layer.cornerRadius=15.0

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
        containerView.addSubview(imageView)
        self.containerView.sendSubviewToBack(imageView)
       }

    @IBAction func sigbUpAction(_ sender: Any) {
        var allowRegister : Bool = true
        
        allowRegister = checkEmptyFields()
        
        if (allowRegister){
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus: "Signing up in progress...")

            SignUp(firstName: firstNameTextField.text!,lastName: lastNameTextField.text!,email: emailTextField.text!,password: passwordTextField.text!)
        }
    }
    
    func SignUp(firstName:String,lastName:String,email:String,password:String) {
        var json: String?
        let parameters: [String: String] = ["email": email, "password": password,"firstName":firstName,"lastName":lastName]
            //create the url with URL
            let url = URL(string: globalUrl + "register")!
            //let url = URL(string: "https://set-out.herokuapp.com/register")!
            //create the session object
            let session = URLSession.shared
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
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
                }
                DispatchQueue.main.async {
                    if (json!.contains("Registration success")){
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.doAction()
                    }else if (json!.contains("Email already exists")){
                        Alert.showCustomAlert(on: self.self, title: "Error", msg: "Email already exists")
                        SVProgressHUD.dismiss()
                    }
                }
            })
            task.resume()
    }
    
    func checkEmptyFields() -> Bool {
        if (firstNameTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "First name can't be empty")
            return false
        }
        if (lastNameTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "Last name can't be empty")
            return false
        }
        if (emailTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "Email name can't be empty")
            return false
        }
        if (passwordTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "Password name can't be empty")
            return false
        }
        if (confirmPasswordTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "Password name can't be empty")
            return false
        }
        
        if (passwordTextField.text! == confirmPasswordTextField.text!) {
        } else {
            Alert.showCustomAlert(on: self, title: "Error", msg: "Passwords Do Not Match")
            return false
        }
        
        return true
    }
}
