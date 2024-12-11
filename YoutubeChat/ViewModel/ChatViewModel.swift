//
//  ChatViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import Foundation

class ChatViewModel{
    
    var categoryArray: [CategoryData] = [CategoryData(title: "검색"),CategoryData(title: "K-pop"),CategoryData(title: "ㅎㅎ"),]
    var chatRoomArray: [ChatRoomData] = []
    var messageArray: [Message] = []
    
    func createChatRoom(chatRoom: ChatRoom) async throws -> ChatRoomData{
        guard let url = URL(string: Constants.baseURL + Endpoints.create) else {
            throw HttpError.badURL
        }
        let response = try await NetworkManager.shared.sendJsonData(chatRoom, ChatRoomData.self, to: url)
        return response
    }
    /*
    func confirmEnterCode(enterCode: String) async throws -> EnterChatResponseData{
        guard let url = URLManager.shared.url(.enterCode) else {
            throw HttpError.badURL
        }
        let data = EnterChatRequestData(enterCode: enterCode, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, EnterChatResponseData.self, to: url)
        return response
    }
    */
    func enterChatRoom(id: UUID, enterCode: String) async throws -> ChatRoomResponseData{
        guard let url = URLManager.shared.url(.enter) else { throw HttpError.badURL }
        let data = EnterChatRoomData(chatRoomId: id, enterCode: enterCode, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, ChatRoomResponseData.self, to: url)
        return response
    }
    
    func leaveChatRoom(id: UUID) async throws -> ResponseData{
        guard let url = URLManager.shared.url(.leave) else { throw HttpError.badURL }
        let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, ResponseData.self, to: url)
        return response
    }
    
    func quitChatRoom(id: UUID) async throws {
        guard let url = URLManager.shared.url(.leave) else { throw HttpError.badURL }
        let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
        _ = try await NetworkManager.shared.sendJsonData(data, ResponseData.self, to: url)
    }
    
    func findChatRoom(id: UUID) async throws -> ChatRoomData?{
        guard let url = URLManager.shared.url(.find) else { throw HttpError.badURL }
        let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
        let response = try await NetworkManager.shared.sendJsonData(data, ChatRoomData?.self, to: url)
        return response
    }
    
    func fetchAllChatRooms(_ completion: @escaping () -> Void) async throws {
        guard let url = URLManager.shared.url(.fetch) else { throw HttpError.badURL }
        self.chatRoomArray = try await NetworkManager.shared.fetchData(to: url, [ChatRoomData].self)
        completion()
    }
    
    func fetchChats(id: UUID, _ completion: @escaping () -> Void) async throws {
        guard let url = URLManager.shared.url(.fetchChats) else { throw HttpError.badURL }
        let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
        self.messageArray = try await NetworkManager.shared.sendJsonData(data, [Message].self, to: url)
        print(messageArray.count)
        completion()
    }
    
    func isPrevSender(_ index: Int)-> Bool{
        if index == 0 {
            return false
        }
        
        var isPrevSender = false
        
        let previousUser = messageArray[index - 1]
        let currentUser = messageArray[index]
        if currentUser.senderId == previousUser.senderId && (previousUser.messageType == .text || previousUser.messageType == .image) {
            isPrevSender = true
        }
        
        return isPrevSender
    }
    
    func optionText(_ chatRoom: ChatRoomData)-> String{
        var text = "\(chatRoom.participantIds.count)명 참여중"
        
        /*
        chatRoom.chatOptions.forEach { option in
            text.append(" ")
            if let type = ChatOption(rawValue: option){
                text.append(ChatOptionData(chatOption: type).title)
            }
        }
        */
        
        return text
    }
}

//MARK: - Message 관련
extension ChatViewModel{
    func sendMessage(_ data: Message){
        WebSocketManager.shared.sendMessage(data)
    }
    
    func receiveMessage(_ data: Message){
        messageArray.append(data)
        // CoreDataManager.shared.saveMessage(data)
    }
    
    func sendEnterMessage(_ id: UUID){
        let message = Message(chatRoomId: id, senderId: MyProfile.id, messageType: .enter)
        sendMessage(message)
    }
    
    func sendLeaveMessage(_ id: UUID){
        let message = Message(chatRoomId: id, senderId: MyProfile.id, messageType: .leave)
        sendMessage(message)
    }
}

//MARK: - 참가자 관련
extension ChatViewModel{
    func findUser(chatRoom: ChatRoomData?, senderId: UUID) -> User?{
        if let chatRoom = chatRoom{
            for participant in chatRoom.participants {
                if participant.id == senderId{
                    return participant
                }
            }
        }
        
        return nil
    }
    
    func setChatRoomParticipants(chatRoom: ChatRoomData, participantData: ParticipantData) -> ChatRoomData {
        var chatRoom = chatRoom
        let user = participantData.user
        
        if let id = user.id {
            if participantData.type == .enter {
                chatRoom.participantIds.append(id)
                if chatRoom.participants.filter({ $0.id == id }).first == nil {
                    chatRoom.allParticipantIds.append(id)
                    chatRoom.participants.append(user)
                }
            } else if participantData.type == .leave {
                if let index = chatRoom.participantIds.firstIndex(where: { $0 == id }) {
                    chatRoom.participantIds.remove(at: index)
                }
            }
        }
        
        return chatRoom
    }
}
