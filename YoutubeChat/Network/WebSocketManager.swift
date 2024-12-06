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
        guard let url = URL(string: "wss://youtubechatsever.onrender.com/chat/message") else {
            print("🌀 Websocket URL Error")
            return
        }
//         let url = URL(string: "ws://127.0.0.1:8080/chat/message")!
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
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
                print("1️⃣ 진입")
            case .video:
                let addVideoResponseData = try JSONDecoder().decode(AddVideoResponseData.self, from: sendData.data)
                NotificationCenter.default.post(name: .receiveVideo, object: nil, userInfo: ["video" : addVideoResponseData])
                print("2️⃣ 진입")
            }
        } catch {
            print("🌀 JSONDecoding Error: \(error.localizedDescription)")
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
