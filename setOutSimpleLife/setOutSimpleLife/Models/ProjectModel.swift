//
//  ProjectModel.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//

import Foundation

struct AllProject:Codable {
    var message:String
    var projects: [ProjectModel]
}


struct ProjectModel:Codable {
      var projectName: String!
      var _id: String!
      var description: String!
      var dateCreation: String!
      var tag:TagModel!
      var tasks: [TaskModel]!
}

