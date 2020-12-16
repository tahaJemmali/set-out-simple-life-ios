//
//  TagModel.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//

import Foundation

struct AllTags:Codable {
    var message:String
    var tags: [TagModel]
}

struct TagModel:Codable {
  var _id:String!
  var tagName:String!
  var color:String!
}
