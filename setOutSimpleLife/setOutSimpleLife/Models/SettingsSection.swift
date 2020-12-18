//
//  SettingsSection.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

protocol SectionType : CustomStringConvertible{
    var containsSwitch: Bool { get }
    var containsEditText : Bool { get }
    
}

enum  SettingsSection:Int,CaseIterable,CustomStringConvertible{
    case PersonalInformations
    case General
    case Prefrences
    case Information
    
    var description: String{
        switch self {
        case .PersonalInformations:
            return "Personal Informations"
        case .General:
            return "General"
        case .Prefrences:
            return "Prefrences"
        case .Information:
            return "Information"
        }
    }
}

enum PersonalInformationsOptions:Int,CaseIterable,SectionType {
    var containsEditText: Bool {
        return false
    }
    
    case editProfile
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self {
        case .editProfile:
            return "Edit personal informations"
    }
}
    
}
enum GeneralOptions:Int,CaseIterable,SectionType {
    case logOut
    case language
    
    var containsEditText: Bool {
        return false
    }
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self {
        case .logOut:
            return "Log out"
        case .language:
            return "Language"
    }
    }
}

enum PrefrencesOptions:Int,CaseIterable,SectionType {
    
    var containsEditText: Bool {
        return false
    }
    
    var containsSwitch: Bool {
        return true
    }
    
    case notifications
    
    var description: String{
        switch self {
        case .notifications:
            return "Notifications"
    }
    }
}

enum InformationOptions:Int,CaseIterable,SectionType {
    
    var containsEditText: Bool {
        return false
    }
    
    case appVersion
    case aboutUs
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self {
        case .appVersion:
            return "App version"
        case .aboutUs:
            return "About us"
    }
    }
}
