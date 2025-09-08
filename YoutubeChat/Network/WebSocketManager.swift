//
//  WebSocketManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/12/24.
//

import Foundation

final class WebSocketManager {
  static let shared = WebSocketManager()
  
  private var webSocketTask: URLSessionWebSocketTask?
  private var reconnectAttempts = 0
  
  func connect() {
    guard let url = Constant.local.websocketURL else {
      print("🌀 Websocket URL Error")
      return
    }
    webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
    webSocketTask?.resume()
    receiveMessage()
    print("☃️ WebSocket 연결중")
    
    Task { @MainActor in
      NotificationCenter.default.post(name: .reconnected, object: nil)
    }
  }
  
  private func reconnect() {
    reconnectAttempts += 1
    
    let delay = min(Double(reconnectAttempts), 5.0)
    
    Task {
      try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
      self.connect()
    }
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
        self?.reconnect()
      case .success(let message):
        switch message {
        case .string(let text):
          print("Received text: \(text)")
        case .data(let data):
          print("Received data: \(data)")
          do {
            try self?.decodingData(data)
          } catch {
            print("Error handling result: \(error)")
          }
        @unknown default:
          print("⚠️ Received unknown message type")
        }
        
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
        Task { @MainActor in
          NotificationCenter.default.post(name: .receiveMessage, object: nil, userInfo: ["message" : message])
        }
      case .addVideo:
        let videoResponseData = try JSONDecoder().decode(VideoResponseData.self, from: sendData.data)
        if let video = videoResponseData.video{
          Task { @MainActor in
            NotificationCenter.default.post(name: .receiveAddVideo, object: nil, userInfo: ["video" : video])
          }
        }
      case .deleteVideo:
        let videoResponseData = try JSONDecoder().decode(VideoResponseData.self, from: sendData.data)
        if let video = videoResponseData.video{
          Task { @MainActor in
            NotificationCenter.default.post(name: .receiveDeleteVideo, object: nil, userInfo: ["video" : video])
          }
        }
      case .participant:
        let participantData = try JSONDecoder().decode(User.self, from: sendData.data)
        Task { @MainActor in
          NotificationCenter.default.post(name: .receiveParticipant, object: nil, userInfo: ["participant" : participantData])
        }
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
