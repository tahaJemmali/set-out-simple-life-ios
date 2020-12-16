//
//  SettingsViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

import UIKit
import SVProgressHUD
private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // temp solution
        configureUI()
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.barStyle = .default
        //navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        //navigationItem.title = "Settings"
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section =  SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .PersonalInformations:
            return PersonalInformationsOptions.allCases.count
        case .General:
            return GeneralOptions.allCases.count
        case .Prefrences:
            return PrefrencesOptions.allCases.count
        case .Information:
            return InformationOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        //view.backgroundColor = .grey

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section =  SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}

        switch section {
        case .PersonalInformations:
            let pinfo = PersonalInformationsOptions(rawValue: indexPath.row)
            //cell.textLabel?.text = pinfo?.description
            cell.sectionType = pinfo
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .General:
            let general = GeneralOptions(rawValue: indexPath.row)
            //cell.textLabel?.text = general?.description
            cell.sectionType = general
        case .Prefrences:
            //cell.accessoryType = .disclosureIndicator
//            let image = UIImage(named:"white")
//            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//            disclosureImageView.image = image
//            disclosureImageView.backgroundColor = .white
//            cell.accessoryView = disclosureImageView
//            cell.switchControl.sendSubviewToBack(disclosureImageView)
            let pref = PrefrencesOptions(rawValue: indexPath.row)
            //cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            cell.sectionType = pref
            //cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        case .Information:
            let info = InformationOptions(rawValue: indexPath.row)
            cell.sectionType = info
            //cell.textLabel?.text = info?.description
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section =  SettingsSection(rawValue: indexPath.section) else {return}

        switch section {
        case .PersonalInformations:
            //print(PersonalInformationsOptions(rawValue: indexPath.row)?.description)
            performSegue(withIdentifier: "editPersonalSegue", sender: self)
        case .General:
            if(GeneralOptions(rawValue: indexPath.row)?.description == "Log out"){
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                UserModel.shared = UserModel()
                
                self.dismiss(animated: true, completion: nil)
                
                SVProgressHUD.dismiss()
            }
            break;
        case .Prefrences:
            //print(PrefrencesOptions(rawValue: indexPath.row)?.description)
            break;
        case .Information:
            //print(InformationOptions(rawValue: indexPath.row)?.description)
            break;
        }
    }
    
}
