//
//  PersonalDetailsViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "SettingsCell"

class PersonalDetailsViewController: UIViewController , UITextFieldDelegate,myProtocol{
    
    func doAction() {
        tableView.reloadData()
    }
    var vc : BirthDatePopUpViewController?

    // MARK: - Properties
    let datePicker = UIDatePicker()
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    var activeTextField = UITextField()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    // MARK: - Init

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        vc = sb.instantiateViewController(withIdentifier: "BirthDatePopUpViewController") as? BirthDatePopUpViewController
        vc!.delegate = self

    }
    @objc func keyboardWillShow(sender: NSNotification) {
        //print(self.activeTextField.tag)
        if self.activeTextField.tag != 10 {
                return
               }
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        //print(self.activeTextField.tag)
        if self.activeTextField.tag != 10 {
                return
               }
         self.view.frame.origin.y = 0 // Move view to original position
    }
    

    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var phone : String = ""
    var address : String = ""
    

    @IBAction func DoneAction(_ sender: Any) {
        var allowUpdate : Bool = true
        
        var i : Int = 0
        let tabTextFields : [UITextField] = getAllTextFields(fromView: self.view)
        for item in  tabTextFields {
            if (item.tag == 1){
                email = item.text!
            }else if (item.tag == 2){
                firstName = item.text!
            }else if (item.tag == 3){
                lastName = item.text!
            }else if (item.tag == 9){
                address = item.text!
            }else if (item.tag == 10){
                phone = item.text!
            }
            i=i+1
        }
        /*print("email :"+email)
        print("first name :"+firstName)
        print("last name :"+lastName)
        print("hometown :"+address)
        print("phone :"+phone)*/
        
        if (email == "" || !email.isValidEmail){
            allowUpdate=false
            Alert.showInvalidEmailAlert(on: self.self)
            return
        }
        
        if (firstName == "" || !firstName.isValidName){
            allowUpdate=false
            Alert.showInvalidFirstNameAlert(on: self.self)
            return
        }
        
        if (lastName == "" || !lastName.isValidName){
            allowUpdate=false
            Alert.showInvalidLastNameAlert(on: self.self)
            return
        }
        
        //if(phone != "Not mentioned"){
        if (phone == "" || (phone.count < 8 && phone.count > 14) || !phone.isNumeric ){
            allowUpdate=false
            Alert.showInvalidPhoneAlert(on: self.self)
            return
        }
        
        
        if (address == "" || !address.isValidName){
            allowUpdate=false
            Alert.showInvalidAddressAlert(on: self.self)
            return
        }

        
        if (allowUpdate){
            //TODO send api update user
            
            let alertForPasswordCheck = UIAlertController(title: "Password Check", message: "Entere your password to confirm your action", preferredStyle: .alert)
            alertForPasswordCheck.addTextField(configurationHandler: nil)
            alertForPasswordCheck.textFields![0].placeholder = "Password..."
            alertForPasswordCheck.textFields![0].isSecureTextEntry = true
            alertForPasswordCheck.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                (_) in return
            }))
            alertForPasswordCheck.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
                (_) in // print(alertForPasswordCheck.textFields![0].text!)
                self.updateEmailUser(oldEmail:UserModel.shared.email!,newEmail:self.email,pwd:alertForPasswordCheck.textFields![0].text!)
            }))
            
            self.present(alertForPasswordCheck, animated: true, completion: nil)
            //print("going to update")
            //SVProgressHUD.dismiss()
            //self.updateEmailUser(oldEmail:UserModel.shared.email!,newEmail:email,pwd:"12345678")
        }
    
    }
    
    func updateEmailUser(oldEmail:String,newEmail:String,pwd:String)  {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        var json: String?
        var parameters : [String: String]
        if UserModel.shared.birth_date != nil {
            parameters = ["oldEmail": oldEmail,"newEmail":newEmail,"password":pwd,"firstName": self.firstName,"lastName":self.lastName,"address":self.address,"phone":self.phone,"birth_date":self.getStringFromDateToDb(date: UserModel.shared.birth_date!)]
        }else{
        parameters = ["oldEmail": oldEmail,"newEmail":newEmail,"password":pwd,"firstName": self.firstName,"lastName":self.lastName,"address":self.address,"phone":self.phone]
        }
            let url = URL(string: "http://localhost:3000/updateUserEmail")!
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
                }
                DispatchQueue.main.async {
                     if (json!.contains("Wrong password")){
                        SVProgressHUD.dismiss()
                        Alert.showCustomAlert(on: self.self, title: "Error", msg: "Wrong password")
                    }
                    else if (json!.contains("Email already exists")){
                        SVProgressHUD.dismiss()
                        Alert.showCustomAlert(on: self.self, title: "Error", msg: "Email Already exists")
                    }else if (json!.contains("Email updated")){
                        
                        //Alert.showCustomAlert(on: self.self, title: "Done", msg: "Email updated")
                        //self.backAction()
                        UserModel.shared.email = newEmail
                        UserModel.shared.firstName = self.firstName
                        UserModel.shared.lastName = self.lastName
                        UserModel.shared.phone = self.phone
                        UserModel.shared.address = self.address

                        //self.updateUser()

                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Done!", message: "Profile updated", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            //self.dismiss(animated: true, completion: nil)
                            self.backAction()
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            })
            task.resume()
    }
    
    /*func updateUser(){
        var json: String?
        let parameters: [String: String] = [,"id":UserModel.shared.id!]

            let url = URL(string: "http://localhost:3000/updateUser")!
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
                }
                DispatchQueue.main.async {
                     if (json!.contains("Done")){
                        
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Done!", message: "Profile updated", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            //self.dismiss(animated: true, completion: nil)
                            self.backAction()
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            })
            task.resume()
    }*/
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        //User Header
        /*let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader*/
        
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        //navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.barStyle = .default
        //navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Personal Details"
    }

}

extension PersonalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsPersonalDetailsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section =  SettingsPersonalDetailsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Id:
            return idOptions.allCases.count
        case .Profile:
            return profileOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        title.text = SettingsPersonalDetailsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section =  SettingsPersonalDetailsSection(rawValue: indexPath.section) else {return UITableViewCell()}

        switch section {
        case .Id:
            let id = idOptions(rawValue: indexPath.row)
            cell.sectionType = id
            switch idOptions(rawValue: indexPath.row) {
            case .connectedWith:
                cell.textFieldControl.text = UserModel.shared.signed_up_with
                cell.textFieldControl.textColor = .gray
                cell.textFieldControl.isUserInteractionEnabled = false;
                cell.isUserInteractionEnabled = false;
            case .email:
                cell.textFieldControl.placeholder = "Email required"
                cell.textFieldControl.text = UserModel.shared.email
                cell.textFieldControl.tag = 1
            default:
                break;
            }
        case .Profile:
            let profile = profileOptions(rawValue: indexPath.row)
            cell.sectionType = profile
            
            switch profileOptions(rawValue: indexPath.row) {
            case .firstNname:
                cell.textFieldControl.placeholder = "First name required"
                cell.textFieldControl.text = UserModel.shared.firstName
                cell.textFieldControl.tag = 2
            case .lastName:
                cell.textFieldControl.placeholder = "Last name required"
                cell.textFieldControl.text =  UserModel.shared.lastName
                cell.textFieldControl.tag = 3
            case .dateOfBirth:
                
                /*let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
                cell.textFieldControl.inputAccessoryView = toolbar
                cell.textFieldControl.inputView = datePicker
                */
                cell.textFieldControl.isUserInteractionEnabled = false;
                if UserModel.shared.birth_date != nil {
                    cell.textFieldControl.text = getStringFromDate(date: UserModel.shared.birth_date!)
                }else{
                    cell.textFieldControl.text = "Not mentioned"
                }
                
            case .country:
                cell.textFieldControl.text = "Tunisia"
                cell.textFieldControl.textColor = .gray
                cell.textFieldControl.isUserInteractionEnabled = false;
                cell.isUserInteractionEnabled = false;
            case .homeTown:
                cell.textFieldControl.placeholder = "optional"
                cell.textFieldControl.text = UserModel.shared.address
                cell.textFieldControl.tag = 9
            case .phone:
                cell.textFieldControl.placeholder = "optional"
                cell.textFieldControl.text = UserModel.shared.phone
                cell.textFieldControl.keyboardType = .numberPad
                cell.textFieldControl.tag = 10
            case .memberSince:
                cell.textFieldControl.textColor = .gray
                cell.textFieldControl.isUserInteractionEnabled = false;
                cell.isUserInteractionEnabled = false;
                if UserModel.shared.sign_up_date != nil {
                    cell.textFieldControl.text = getStringFromDate(date: UserModel.shared.sign_up_date!)
                }else{
                    cell.textFieldControl.text = "Not mentioned"
                }
            default:
                break;
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section =  SettingsPersonalDetailsSection(rawValue: indexPath.section) else {return}

        switch section {
        case .Id:
            //print(idOptions(rawValue: indexPath.row)?.description)
            break;
        case .Profile:
            //print(profileOptions(rawValue: indexPath.row)?.description)
            if (profileOptions(rawValue: indexPath.row)?.description == "Date of Birth"){
                //performSegue(withIdentifier: "birthDaySegue", sender: self)
                self.present(vc!, animated: true)
            }
            
            break;
        }
    }


    func getStringFromDate(date:NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let myString = formatter.string(from: date as Date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func getStringFromDateToDb(date:NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let myString = formatter.string(from: date as Date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.flatMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
}
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    var isValidName:Bool {
        if (self.count > 3 && self.count < 18)
        {
        return  NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$").evaluate(with: self)
        }
        return false
    }
    var isNumeric: Bool {
            guard self.count > 0 else { return false }
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            return Set(self).isSubset(of: nums)
        }
}

