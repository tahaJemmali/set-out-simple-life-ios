//
//  SettingsPersonalDetailsSection.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

//
//  SettingsSection.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//

enum  SettingsPersonalDetailsSection:Int,CaseIterable,CustomStringConvertible{
    case Id
    case Profile
    
    var description: String{
        switch self {
        case .Id:
            return "ID"
        case .Profile:
            return "Profile"
        }
    }
}

enum idOptions:Int,CaseIterable,SectionType {
    
    var containsEditText: Bool {
        switch self {
        case .email:
            return true
        default:
            return true
        }
    }
    
    case email
    case connectedWith
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self {
        case .email:
            return "Email"
        case .connectedWith:
            return "Connected with"
    }

    }
}

enum profileOptions:Int,CaseIterable,SectionType {
    
    var containsEditText: Bool {
        return true
    }
    
    case firstNname
    case lastName
    case dateOfBirth
    case homeTown
    case phone
    case country
    case memberSince
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self {
        case .firstNname:
            return "First name"
        case .lastName:
            return "Last name"
        case .dateOfBirth:
            return "Date of Birth"
        case .homeTown:
            return "Home Town"
        case .phone:
            return "Phone number"
        case .country:
            return "Country"
        case .memberSince:
            return "Member since"
    }

    }
}

