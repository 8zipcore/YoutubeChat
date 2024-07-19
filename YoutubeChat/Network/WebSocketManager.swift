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
        let url = URL(string: "ws://127.0.0.1:8080/chat/message")!
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func sendMessage(_ chatData: ChatData) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(chatData)
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
                    NotificationCenter.default.post(name: .receiveMessage, object: nil, userInfo: ["chatData" : data])
                    // 받은 데이터를 처리
                @unknown default:
                    fatalError()
                }
                
                // 다시 메시지를 받기 위해 호출
                self?.receiveMessage()
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
