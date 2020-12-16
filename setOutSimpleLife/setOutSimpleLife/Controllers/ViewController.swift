//
//  ViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/19/20.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController,myProtocol {
    
    var vc : SignUpViewController?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var containerUIView: UIView!
    
    @IBOutlet weak var hotmailButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        self.present(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //perform(#selector(advance), with: nil, afterDelay: 2)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        vc = sb.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        vc!.delegate = self
        
        emailTextField.text = "fahd.larayedh@esprit.tn"
        passwordTextField.text = "12345678"
        
        // Do any additional setup after loading the view.
        initUI()
    }

    func doAction() {
        Alert.showCustomAlert(on: self, title: "Registration success", msg: "Welcome!")
    }

    
    func initUI() {
        
        assignbackground()
        
        passwordTextField.isSecureTextEntry = true
        
        loginButton.layer.cornerRadius = 20.0
        containerUIView.layer.cornerRadius=15.0
        
        configureLoginButtons()
    }

    @IBAction func loginAction(_ sender: Any) {
        if (emailTextField.text! == "" || passwordTextField.text! == ""){
            Alert.showIncompleteFormAlert(on: self)
        }else{
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            login(email:emailTextField.text!,password:passwordTextField.text!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue"){
        }
    }
    
    func login(email:String,password:String) {
        var json: String?
        let parameters: [String: String] = ["email": email, "password": password]
            //create the url with URL
            //let url = URL(string: "http://localhost:3000/login")!
        let url = URL(string: "https://set-out.herokuapp.com/login")!
            
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
                    if (json!.contains("Login success")){
                        
                        self.loadUser(email:email)
                        //self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else if (json!.contains("Wrong password")){
                        SVProgressHUD.dismiss()
                        Alert.showInvalidPasswordAlert(on: self.self)
                    }
                    else if (json!.contains("Email does not exist")){
                        SVProgressHUD.dismiss()
                        Alert.showInvalidEmailAlert(on: self.self)
                    }
                }
            })
            task.resume()
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
    
    
    func configureLoginButtons()  {
        facebookButton.layer.cornerRadius = 0.5 * facebookButton.bounds.size.width
        facebookButton.clipsToBounds = true
        
        gmailButton.layer.cornerRadius = 0.5 * gmailButton.bounds.size.width
        gmailButton.clipsToBounds = true
        
        hotmailButton.layer.cornerRadius = 0.5 * hotmailButton.bounds.size.width
        hotmailButton.clipsToBounds = true
         
    }
    
    func loadUser(email:String) {
        var json: String?

        let url = URL(string: "http://localhost:3000/getUser/"+email)!
            //let url = URL(string: "https://set-out.herokuapp.com/login/fahd.larayedh@esprit.tn/123")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
        
            request.httpMethod = "GET" //set http method as POST
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    return
                }
                
                do {
                        json = String(data: data!,encoding: .utf8)
                    let dataJson = Data(json!.utf8)
                    do{
                    if let jsonArray = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                        
                        //print(jsonArray["message"]!)
                        //print(jsonArray["user"]!)
                        
                        
                        //if let message = jsonArray["message"] as? String {
                            //print(message)
                        //}
                        
                        if let user = jsonArray["user"] as? Dictionary<String,Any> {
//                            print(user["firstName"] ?? "Not mentioned")
//                            print(user["lastName"] ?? "Not mentioned")
//                            print(user["email"] ?? "Not mentioned")
//                            print(user["address"] ?? "Not mentioned")
//                            print(user["phone"] ?? "Not mentioned")
//                            print(user["photo"] ?? "Not mentioned")
//                            print(user["score"] ?? "Not mentioned")
//                            print(user["signed_up_with"] ?? "Not mentioned")
//                            print(user["sign_up_date"] ?? "Not mentioned")
//                            print(user["_id"] ?? "Not mentioned")
//                            print(user["birth_date"] ?? "Not mentioned")
//                            print(user["last_login_date"] ?? "Not mentioned")
                            
                            UserModel.shared.id = ((user["_id"] ?? "Not mentioned") as! String)
                            UserModel.shared.firstName = ((user["firstName"] ?? "Not mentioned") as! String)
                            UserModel.shared.lastName = ((user["lastName"] ?? "Not mentioned") as! String)
                            UserModel.shared.email = ((user["email"] ?? "Not mentioned") as! String)
                            UserModel.shared.address = ((user["address"] ?? "Not mentioned") as! String)
                            UserModel.shared.phone = ((user["phone"] ?? "Not mentioned") as! String)
                            UserModel.shared.photo = ((user["photo"] ?? "Not mentioned") as! String)
                            UserModel.shared.score = ((user["score"] ?? 0 ) as! Int)
                            UserModel.shared.signed_up_with = ((user["signed_up_with"] ?? "Not mentioned") as! String)
                            UserModel.shared.sign_up_date = self.getDate(key: ((user["sign_up_date"]) as! String))
                            
                            UserModel.shared.birth_date = self.getDate(key: ((user["birth_date"]) as! String))
                            //UserModel.shared.last_login_date = self.getDate(key: ((user["last_login_date"]) as! String))
                            
                        }
                    }
                    }catch let err{
                        print(err.localizedDescription)
                    }
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "loginSegue", sender: self)

                    
                   /* if (json!.contains("Login success")){
                        //self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else if (json!.contains("Wrong password")){
                        Alert.showInvalidPasswordAlert(on: self.self)
                    }
                    else if (json!.contains("Email does not exist")){
                        Alert.showInvalidEmailAlert(on: self.self)
                    }*/
                }
            })
            task.resume()
    }
    
    func getDate(key:String) -> NSDate {
        let formatter = DateFormatter()

      // Format 1
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: key) {
            return parsedDate as NSDate
      }

      // Format 2
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: key) {
            return parsedDate as NSDate
      }
        return NSDate()
    }
}

protocol myProtocol {
     func doAction()
}

