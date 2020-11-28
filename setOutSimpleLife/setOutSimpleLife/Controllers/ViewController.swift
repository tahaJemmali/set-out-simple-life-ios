//
//  ViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/19/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var containerUIView: UIView!
    
    @IBOutlet weak var hotmailButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "fahd.larayedh@esprit.tn"
        passwordTextField.text = "1234"
        // Do any additional setup after loading the view.
        initUI()
    }

    func initUI() {
        
        assignbackground()
        
        passwordTextField.isSecureTextEntry = true
        
        loginButton.layer.cornerRadius = 20.0
        containerUIView.layer.cornerRadius=15.0
        
        configureLoginButtons()
    }

    @IBAction func loginAction(_ sender: Any) {
        //print("login clicked")
        if (emailTextField.text! == "" || passwordTextField.text! == ""){
            Alert.showIncompleteFormAlert(on: self)
        }else{
            login(email:emailTextField.text!,password:passwordTextField.text!)
        }
        //print("aaa  : ",Global.message)
        //performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue"){
        }
    }
    
    func login(email:String,password:String) {
        var json: String?
        let parameters: [String: String] = ["email": email, "password": password]
            //create the url with URL
            let url = URL(string: "http://localhost:3000/login")!
            //let url = URL(string: "https://set-out.herokuapp.com/login")!
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
                /*guard let data = data else {
                    return
                }*/
                do {
                    //create json object from data
                    /*if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print("ff")
                        print(json)
                        print("ff")
                        // handle json...
                    }*/
                    //let gitData = try JSONDecoder().decode([Root].self, from: data)
                    //print(gitData)
                    /*let jsonResponse = try JSONSerialization.jsonObject(with:
                                                   data, options: [])
                            print(jsonResponse) //Response result*/
                        json = String(data: data!,encoding: .utf8)
                    //print("json response := ",json!)
                    
                } /*catch let error {
                    print(error.localizedDescription)
                }*/
                DispatchQueue.main.async {
                    if (json!.contains("Login success")){
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else if (json!.contains("Wrong password")){
                        Alert.showInvalidPasswordAlert(on: self.self)
                    }
                    else if (json!.contains("Email does not exist")){
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
}

/*struct Root : Codable{
    public var response : String!
}
*/
/*
struct Global {
    static var message: String?

    static func setMessage(message:String) {
        Global.message = message
    }
}*/


