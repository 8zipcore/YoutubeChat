//
//  ChatViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import Foundation

class ChatViewModel{
    
    var chatOptionArray = [ChatOptionData(chatOption: .anonymous),
                           ChatOptionData(chatOption: .addVideo),
                           ChatOptionData(chatOption: .privateRoom)]
    
    var myChatRoomArray: [ChatRoom] = []
    var messageArray: [Message] = []
    
    func createChatRoom(chatRoom: ChatRoom) async throws -> ChatRoom{
        guard let url = URL(string: Constants.baseURL + Endpoints.createChat) else {
            throw HttpError.badURL
        }
        let response = try await NetworkManager.shared.sendJsonData(chatRoom, to: url)
        // saveChatRoom(chatRoom: response)
        return response
    }
    
    func confirmEnterCode(enterCode: String) async throws -> EnterChatResponseData{
        guard let url = URLManager.shared.url(.enterCode, nil) else {
            throw HttpError.badURL
        }
        let data = EnterChatRequestData(enterCode: enterCode, userID: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, EnterChatResponseData.self, to: url)
        return response
    }
    
    func saveChatRoom(chatRoom: ChatRoom){
        // CoreDataManager.shared.saveChatRoom(chatRoom)
    }
    
    func updateChatRoom(chatRoom: ChatRoom){
        // CoreDataManager.shared.updateChatRoom(chatRoom)
    }
    
    func fetchChatRoom(id: UUID) async throws -> ChatRoom{
        guard let url = URLManager.shared.url(.fetchChat, id.uuidString) else { throw HttpError.badURL }
        let response = try await NetworkManager.shared.fetchData(to: url, ChatRoom.self)
        // updateChatRoom(chat: response)
        return response
    }
    
    func selectedChatOptions()-> [Int]{
        var selectedChatOptions: [Int] = []
        
        chatOptionArray.forEach{
            if $0.isSelected{
                selectedChatOptions.append($0.chatOption.rawValue)
            }
        }
        
        return selectedChatOptions
    }
    
    func sendMessage(_ data: Message){
        WebSocketManager.shared.sendMessage(data)
    }
    
    func receiveMessage(_ data: Message){
        messageArray.append(data)
        // CoreDataManager.shared.saveMessage(data)
    }
    
    func fetchMessage(_ id: UUID){
        // messageArray = CoreDataManager.shared.fetchMessage(id)
    }
    
    func isPrevSender(_ index: Int)-> Bool{
        if index == 0 {
            return false
        }
        
        var isPrevSender = false
        
        let previousUser = messageArray[index - 1]
        let currentUser = messageArray[index]
        if currentUser.senderId == previousUser.senderId{
            isPrevSender = true
        }
        
        return isPrevSender
    }
}
