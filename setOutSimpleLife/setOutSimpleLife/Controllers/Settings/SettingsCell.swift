//
//  SettingsCell.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var sectionType : SectionType? {
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            textFieldControl.isHidden = !sectionType.containsEditText
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    // MARK: - Init
    
    lazy var textFieldControl: UITextField = {
        let textField = UITextField()
        textField.textColor =  UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(handleTextFieldAction), for: .editingChanged)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchControl)
        contentView.addSubview(textFieldControl)
        
        textFieldControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //textFieldControl.rightAnchor.constraint(equalTo: rightAnchor,constant: -12).isActive = true
        textFieldControl.leftAnchor.constraint(equalTo: leftAnchor,constant: 200).isActive = true
        
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor,constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    @objc func handleSwitchAction(sender: UISwitch){
        if sender.isOn{
            print("Turned On")
        }else{
            print("Turned Off")
        }
    }
    @objc func handleTextFieldAction(sender: UITextField){
    
        //print(sender.text!)
    }
    
    
}
