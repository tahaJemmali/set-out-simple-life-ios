//
//  WebSocketController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/11/20.
//


import Foundation
import SwiftUI

struct AlertWrapper: Identifiable {
  let id = UUID()
  let alert: Alert
}

final class WebSocketController: ObservableObject {
  @Published var questions: [UUID: NewQuestionResponse]
  @Published var alertWrapper: AlertWrapper?
  
  var alert: Alert? {
    didSet {
      guard let a = self.alert else { return }
      DispatchQueue.main.async {
        self.alertWrapper = .init(alert: a)
      }
    }
  }
  
  private var id: UUID!
  private let session: URLSession
  var socket: URLSessionWebSocketTask!
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  init() {
    self.questions = [:]
    self.alertWrapper = nil
    self.alert = nil
    
    self.session = URLSession(configuration: .default)
    self.connect()
  }
  
  func connect() {
    self.socket = session.webSocketTask(with: URL(string: "ws://10.0.2.2:3001")!)
    self.listen()
    self.socket.resume()
  }
  
  func addQuestion(_ content: String) {
    guard let id = self.id else { return }
    // 1
    let message = NewQuestionMessage(id: id, content: content)
    do {
      // 2
      let data = try encoder.encode(message)
      // 3
      self.socket.send(.data(data)) { (err) in
        if err != nil {
          print(err.debugDescription)
        }
      }
    } catch {
      print(error)
    }
  }
  
  func handle(_ data: Data) {
    do {
      // 1
      let sinData = try decoder.decode(QnAMessageSinData.self, from: data)
      // 2
      switch sinData.type {
      case .handshake:
        // 3
        print("Shook the hand")
        let message = try decoder.decode(QnAHandshake.self, from: data)
        self.id = message.id
      // 4
      case .questionResponse:
        try self.handleQuestionResponse(data)
      case .questionAnswer:
        try self.handleQuestionAnswer(data)
      default:
        break
      }
    } catch {
      print(error)
    }
  }
  
  func listen() {
    // 1
    self.socket.receive { [weak self] (result) in
      guard let self = self else { return }
      // 2
      switch result {
      case .failure(let error):
        print(error)
        // 3
//        let alert = Alert(
//            title: Text("Unable to connect to server!"),
//            dismissButton: .default(Text("Retry")) {
//              self.alert = nil
//              self.socket.cancel(with: .goingAway, reason: nil)
//              self.connect()
//            }
//        )
//        self.alert = alert
        return
      case .success(let message):
        // 4
        switch message {
        case .data(let data):
          self.handle(data)
        case .string(let str):
          guard let data = str.data(using: .utf8) else { return }
          self.handle(data)
        @unknown default:
          break
        }
      }
      // 5
      self.listen()
    }
  }
  
  func handleQuestionAnswer(_ data: Data) throws {
    // 1
    let response = try decoder.decode(QuestionAnsweredMessage.self, from: data)
    DispatchQueue.main.async {
      // 2
      guard let question = self.questions[response.questionId] else { return }
      question.answered = true
      self.questions[response.questionId] = question
    }
  }
  
  func handleQuestionResponse(_ data: Data) throws {
    // 1
    let response = try decoder.decode(NewQuestionResponse.self, from: data)
    DispatchQueue.main.async {
      if response.success, let id = response.id {
        // 2
        self.questions[id] = response
//        let alert = Alert(title: Text("New question recieved!"), message: Text(response.message), dismissButton: .default(Text("OK")) { self.alert = nil })
//        self.alert = alert
      } else {
        // 3
//        let alert = Alert(title: Text("Something went wrong!"), message: Text(response.message), dismissButton: .default(Text("OK")) { self.alert = nil })
//        self.alert = alert
      }
    }
  }
}
