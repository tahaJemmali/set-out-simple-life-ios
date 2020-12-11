//
//  TaskModel.swift
//  setOutSimpleLife
//
//  Created by taha on 03/12/2020.
//

import Foundation

struct AllTasks:Codable {
    var message:String
    var tasks: [TaskModel]!
}


struct TaskModel:Codable {
   var _id: String
   var taskName: String
   var importance: Int
   var enjoyment: Int
   var note: String
   var dateCreation: String
   var deadline: String
   var reminder: String
   var schedule: Bool
   // var tag:TagModel
}

struct AllSchedules:Codable {
    var message:String
    var tasks: [ScheduleModel]!
}

struct ScheduleModel:Codable {
      var _id: String
     var taskName: String
     var importance: Int
     var enjoyment: Int
     var note: String
     var dateCreation: String
     var endTime: String
     var schedule: Bool
}
