//
//  UserModel.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/5/20.
//

import Foundation

    class UserModel: NSObject {
        static var shared: UserModel = UserModel()
        var firstName :String?
        var lastName : String?
        var email : String?
        var address : String?
        var phone : String?
        var photo : String?
        var score : Int?
        var id : String?
        var signed_up_with : String?
        var sign_up_date : NSDate?
        var birth_date : NSDate?
        var last_login_date : NSDate?

    }

struct User {
    var firstName :String?
    var lastName : String?
    var email : String?
    var address : String?
    var phone : String?
    var photo : String?
    var score : Int?
    var id : String?
    var signed_up_with : String?
    var sign_up_date : NSDate?
    var birth_date : NSDate?
    var last_login_date : NSDate?

}
