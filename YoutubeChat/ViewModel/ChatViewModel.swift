//
//  ChatViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import Foundation

class ChatViewModel{
    
    var chatOptionArray = [ChatOptionData(chatOption: .anonymous),
                           ChatOptionData(chatOption: .addVideo)]
    
    var myChatArray: [Chat] = []
    var messageArray: [Message] = []
    
    func createGroupChat(chatInfo: Chat) async throws -> Chat{
        guard let url = URL(string: Constants.baseURL + Endpoints.createChat) else {
            throw HttpError.badURL
        }
        let response = try await NetworkManager.shared.sendJsonData(chatInfo, to: url)
        saveChat(chat: response)
        return response
    }
    
    func confirmEnterCode(enterCode: String) async throws -> Chat{
        guard let url = URLManager.shared.url(.enterCode) else {
            throw HttpError.badURL
        }
        let data = EnterChatRequestData(enterCode: enterCode, userID: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, EnterChatResponseData.self, to: url).chat!
        saveChat(chat: response)
        return response
    }
    
    func saveChat(chat: Chat){
        CoreDataManager.shared.saveChat(chat)
    }
    
    func fetchChat(){
        self.myChatArray = CoreDataManager.shared.fetchChat()
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
    }
    
    func fetchMessage(_ id: UUID){
        messageArray = CoreDataManager.shared.fetchMessage(id)
    }
    
    func isPrevSender(_ index: Int)-> Bool{
        if index == 0 {
            return false
        }
        
        var isPrevSender = false
        
        let previousUser = messageArray[index - 1]
        let currentUser = messageArray[index]
        if currentUser.senderID == previousUser.senderID{
            isPrevSender = true
        }
        
        return isPrevSender
    }
}
