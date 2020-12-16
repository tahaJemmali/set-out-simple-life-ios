//
//  PostModel.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/8/20.
//

import Foundation

//class PostModel: NSObject {
//    static let shared: PostModel = PostModel()
//
//    var id :String?
//    var title : String?
//    var text : String?
//    var image : String?
//    var postDate : NSDate?
//    var user : UserModel?
//    var likedBy : [UserModel]?
//    //var comments : [CommentModel]?
//}

struct Post {    
    var id :String?
    var title : String?
    var text : String?
    var image : String?
    var postDate : NSDate?
    var user : User?
    var likedBy : [User]?
    //var comments : [CommentModel]?
}

struct Comment {
    var text : String?
    var commentDate : NSDate?
    var user : User?
}
