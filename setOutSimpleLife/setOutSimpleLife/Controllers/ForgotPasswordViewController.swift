//
//  ForgotPasswordViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/24/20.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBAction func nextButtonAction(_ sender: Any) {
    // performSegue(withIdentifier: "toVerifyCodeSegue", sender: nil)
    //print("bbbbb")
        if (emailTextField.text!.isEmpty){
            Alert.showCustomAlert(on: self, title: "Error", msg: "Email can't be empty")
        }else{
            //call api
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            sendCode(email:emailTextField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        emailTextField.text = "fahd.larayedh@esprit.tn"
    }
 
    func initUI() {

        nextBtn.layer.cornerRadius = 20.0

        assignbackground()
        containerView.layer.cornerRadius=15.0

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

    func sendCode(email:String) {
        var json: String?
        var infos:(email: String, code: String)?
        var stringCode : String?
        var stringEmail : String?

        //print("email : ",email)
        let parameters: [String: String] = ["email": email]
            //create the url with URL
        //let s : String = "http://localhost:3000/passwordRecovery/"+email
            let url = URL(string: "http://localhost:3000/passwordRecovery")!
            //let url = URL(string: "https://set-out.herokuapp.com/passwordRecovery")!
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
                    //print("data : ",json!)
                    
                    let dataJson = Data(json!.utf8)

                    if let jsonArray = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                        //print(jsonArray["message"]!)
                        if let code = jsonArray["code"] as? Int {
                            //print("LE CODE : ",code)
                            stringCode = String(code)
                        }
                        if let email = jsonArray["email"] as? String {
                            stringEmail = String(email)
                        }
                    }
                }catch let err{
                    print(err.localizedDescription)
                }
                DispatchQueue.main.async {
                    //self.performSegue(withIdentifier: "toVerifyCodeSegue", sender: "123456")
                    
                    SVProgressHUD.dismiss()
                    
                    if (json!.contains("verification code")){
                       // Alert.showCustomAlert(on: self.self, title: "verification code", msg: "Check your email to get the verification code!")
                        //self.performSegue(withIdentifier: "toVerifyCodeSegue", sender: "123456")
                        
                        var dictSendData:[String] = []
                        dictSendData.append(stringEmail!)
                        dictSendData.append(stringCode!)
                        
                        let alert = UIAlertController(title: "Verification code", message: "Check your email to get the verification code!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.performSegue(withIdentifier: "toVerifyCodeSegue", sender: dictSendData)
                        }))
                        self.present(alert, animated: true)
                        
                    }
                    else if (json!.contains("Email does not exist")){
                        Alert.showInvalidEmailAlert(on: self.self)
                    }
                }
            })
            task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toVerifyCodeSegue"){
        let dictSendData = sender as! [String]
        let destination = segue.destination as! ConfirmCodeViewController
            destination.dictSendData = dictSendData
        }
    }
}
