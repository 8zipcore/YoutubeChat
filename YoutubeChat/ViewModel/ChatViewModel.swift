//
//  ChatViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import Foundation

class ChatViewModel{
    
    var categoryArray: [CategoryData] = [CategoryData(title: "검색"),CategoryData(title: "K-pop"),CategoryData(title: "ㅎㅎ"),]
    var chatOptionArray = [ChatOptionData(chatOption: .anonymous),
                           ChatOptionData(chatOption: .addVideo),
                           ChatOptionData(chatOption: .privateRoom)]
    
    var chatRoomArray: [ChatRoom] = []
    var messageArray: [Message] = []
    
    func createChatRoom(chatRoom: ChatRoom) async throws -> ChatRoom{
        guard let url = URL(string: Constants.baseURL + Endpoints.create) else {
            throw HttpError.badURL
        }
        let response = try await NetworkManager.shared.sendJsonData(chatRoom, to: url)
        // saveChatRoom(chatRoom: response)
        return response
    }
    
    func confirmEnterCode(enterCode: String) async throws -> EnterChatResponseData{
        guard let url = URLManager.shared.url(.enterCode) else {
            throw HttpError.badURL
        }
        let data = EnterChatRequestData(enterCode: enterCode, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, EnterChatResponseData.self, to: url)
        return response
    }
    
    func saveChatRoom(chatRoom: ChatRoom){
        // CoreDataManager.shared.saveChatRoom(chatRoom)
    }
    
    func updateChatRoom(chatRoom: ChatRoom){
        // CoreDataManager.shared.updateChatRoom(chatRoom)
    }
    
    func enterChatRoom(id: UUID) async throws -> ChatRoom{
        guard let url = URLManager.shared.url(.enter) else { throw HttpError.badURL }
        let enterChatRoomData = EnterChatRoomData(chatRoomId: id, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(enterChatRoomData, ChatRoom.self, to: url)
        // updateChatRoom(chat: response)
        return response
    }
    
    func leaveChatRoom(id: UUID) async throws -> ResponseData{
        guard let url = URLManager.shared.url(.leave) else { throw HttpError.badURL }
        let enterChatRoomData = EnterChatRoomData(chatRoomId: id, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(enterChatRoomData, ResponseData.self, to: url)
        // updateChatRoom(chat: response)
        return response
    }
    
    func quitChatRoom(id: UUID) async throws {
        guard let url = URLManager.shared.url(.leave) else { throw HttpError.badURL }
        let enterChatRoomData = EnterChatRoomData(chatRoomId: id, userId: MyProfile.id)
        _ = try await NetworkManager.shared.sendJsonData(enterChatRoomData, ResponseData.self, to: url)
    }
    
    func fetchAllChatRooms(_ completion: @escaping () -> Void) async throws {
        guard let url = URLManager.shared.url(.fetch) else { throw HttpError.badURL }
        self.chatRoomArray = try await NetworkManager.shared.fetchData(to: url, [ChatRoom].self)
        completion()
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
    
    func sendEnterMessage(_ chatRoom: ChatRoom){
        let message = Message(chatRoomId: chatRoom.id!, senderId: MyProfile.id, messageType: .enter, isRead: true)
        sendMessage(message)
    }
    
    func sendLeaveMessage(_ chatRoom: ChatRoom){
        let message = Message(chatRoomId: chatRoom.id!, senderId: MyProfile.id, messageType: .leave, isRead: true)
        sendMessage(message)
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
    
    func optionText(_ chatRoom: ChatRoom)-> String{
        var text = "\(chatRoom.participantIds.count)명 참여중"
        
        chatRoom.chatOptions.forEach { option in
            text.append(" ")
            let type = ChatOption(rawValue: option)
            switch type {
            case .anonymous:
                text.append("/ 익명")
            case .addVideo:
                text.append("/ 동영상 추가 허용")
            case .privateRoom:
                break
            case nil:
                break
            }
        }
        
        return text
    }
}
