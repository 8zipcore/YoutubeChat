//
//  WebSocketManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/12/24.
//

import Foundation

class WebSocketManager {
  static let shared = WebSocketManager()
  
  var webSocketTask: URLSessionWebSocketTask?
  
  func connect() {
    guard let url = URL(string: "wss://\(Constants.domain)/chat/message") else {
      print("🌀 Websocket URL Error")
      return
    }
    webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
    webSocketTask?.resume()
    receiveMessage()
    print("☃️ WebSocket 연결중")
    
    NotificationCenter.default.post(name: .reconnected, object: nil)
  }
  
  func sendMessage(_ message: Message) {
    do {
      let jsonEncoder = JSONEncoder()
      let jsonData = try jsonEncoder.encode(message)
      let data = URLSessionWebSocketTask.Message.data(jsonData)
      webSocketTask?.send(data) { error in
        if let error = error {
          print("WebSocket sending error: \(error)")
        }
      }
    } catch {
      print("jsonEncoder Error")
    }
  }
  
  
  func receiveMessage() {
    webSocketTask?.receive { [weak self] result in
      switch result {
      case .failure(let error):
        print("WebSocket receiving error: \(error)")
      case .success(let message):
        switch message {
        case .string(let text):
          print("Received text: \(text)")
          
          // 받은 메시지를 처리
        case .data(let data):
          print("Received data: \(data)")
          do {
            try self?.decodingData(data)
          } catch {
            print("Error handling result: \(error)")
          }
          
          // 받은 데이터를 처리
        @unknown default:
          fatalError()
        }
        
        // 다시 메시지를 받기 위해 호출
        self?.receiveMessage()
      }
    }
  }
  
  func decodingData(_ data: Data) throws {
    do {
      let sendData = try JSONDecoder().decode(SendData.self, from: data)
      
      switch sendData.type{
      case .message:
        let message = try JSONDecoder().decode(Message.self, from: sendData.data)
        NotificationCenter.default.post(name: .receiveMessage, object: nil, userInfo: ["message" : message])
      case .addVideo:
        let videoResponseData = try JSONDecoder().decode(VideoResponseData.self, from: sendData.data)
        if let video = videoResponseData.video{
          NotificationCenter.default.post(name: .receiveAddVideo, object: nil, userInfo: ["video" : video])
        }
      case .deleteVideo:
        let videoResponseData = try JSONDecoder().decode(VideoResponseData.self, from: sendData.data)
        if let video = videoResponseData.video{
          NotificationCenter.default.post(name: .receiveDeleteVideo, object: nil, userInfo: ["video" : video])
        }
      case .participant:
        let participantData = try JSONDecoder().decode(User.self, from: sendData.data)
        NotificationCenter.default.post(name: .receiveParticipant, object: nil, userInfo: ["participant" : participantData])
      }
    } catch {
      print("🌀 JSONDecoding Error: \(error.localizedDescription)")
    }
  }
  
  func disconnect() {
    print("☔️ WebSocket disconnect")
    webSocketTask?.cancel(with: .goingAway, reason: nil)
    webSocketTask = nil
  }
}
