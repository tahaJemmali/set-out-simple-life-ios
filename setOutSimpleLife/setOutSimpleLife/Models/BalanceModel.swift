//
//  BalanceModel.swift
//  setOutSimpleLife
//
//  Created by taha on 11/12/2020.
//

import Foundation

struct AllBalances:Codable {
    var message:String
    var balances: [BalanceModel]
}

struct BalanceModel:Codable {
  var _id:String!
  var balanceName:String!
  var balanceAmount:Double!
    var dateCreation:String!
    var type:String!
}

