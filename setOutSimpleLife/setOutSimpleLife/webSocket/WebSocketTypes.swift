//
//  WebSocketTypes.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/11/20.
//


import Foundation

enum QnAMessageType: String, Codable {
  // Client to server types
  case newQuestion
  // Server to client types
  case questionResponse, handshake, questionAnswer
}

struct QnAMessageSinData: Codable {
  let type: QnAMessageType
}

struct QnAHandshake: Codable {
  let id: UUID
}

struct NewQuestionMessage: Codable {
  var type: QnAMessageType = .newQuestion
  let id: UUID
  let content: String
}

class NewQuestionResponse: Codable, Comparable {
  let success: Bool
  let message: String
  let id: UUID?
  var answered: Bool
  let content: String
  let createdAt: Date?
  
  static func < (lhs: NewQuestionResponse, rhs: NewQuestionResponse) -> Bool {
    guard let lhsDate = lhs.createdAt, let rhsDate = rhs.createdAt else { return false }
    return lhsDate < rhsDate
  }
  
  static func == (lhs: NewQuestionResponse, rhs: NewQuestionResponse) -> Bool {
    lhs.id == rhs.id
  }
}

struct QuestionAnsweredMessage: Codable {
  let questionId: UUID
}
