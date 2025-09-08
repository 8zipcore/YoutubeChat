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
  
  func createChatRoom(chatRoom: ChatRoom, imageData: Data?) async throws -> ChatRoomData{
    guard let createURL = URLManager.shared.url(for: ChatEndpoint.create),
            let uploadImageURL = URLManager.shared.url(for: ChatEndpoint.uploadImage) else {
      throw HttpError.badURL
    }
    var response = try await NetworkManager.shared.sendJsonData(chatRoom, ChatRoomData.self, to: createURL)
    
    var imageDataSet: [String : Data] = [:]
    if let imageData = imageData{
      imageDataSet = ["image" : imageData]
    }
    
    response.image = try await NetworkManager.shared.sendImageAndMetadata(to: uploadImageURL, ImageAndMetaData(parameters: ["id" : response.id!.uuidString], imageDataSet: imageDataSet), ResponseWithStringData.self).string
    print(" 😳 : \(response.image)")
    return response
  }
  
  func updateChatRoom(chatRoom: ChatRoom, imageData: Data?) async throws -> ChatRoomData{
    guard let updateChatRoomURL = URLManager.shared.url(for: ChatEndpoint.update),
          let uploadImageURL = URLManager.shared.url(for: ChatEndpoint.uploadImage) else {
      throw HttpError.badURL
    }
    var response = try await NetworkManager.shared.sendJsonData(chatRoom, ChatRoomData.self, to: updateChatRoomURL)
    
    var imageDataSet: [String : Data] = [:]
    if let imageData = imageData{
      imageDataSet = ["image" : imageData]
    }
    
    response.image = try await NetworkManager.shared.sendImageAndMetadata(to: uploadImageURL, ImageAndMetaData(parameters: ["id" : response.id!.uuidString], imageDataSet: imageDataSet), ResponseWithStringData.self).string
    
    return response
  }

  func enterChatRoom(id: UUID, enterCode: String) async throws -> ChatRoomResponseData{
    guard let url = URLManager.shared.url(for: ChatEndpoint.enter) else { throw HttpError.badURL }
    let data = EnterChatRoomData(chatRoomId: id, enterCode: enterCode, userId: MyProfile.id)
    let response = try await NetworkManager.shared.sendJsonData(data, ChatRoomResponseData.self, to: url)
    return response
  }
  
  func leaveChatRoom(id: UUID) async throws -> ResponseData{
    guard let url = URLManager.shared.url(for: ChatEndpoint.leave) else { throw HttpError.badURL }
    let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
    let response = try await NetworkManager.shared.sendJsonData(data, ResponseData.self, to: url)
    return response
  }
  
  func quitChatRoom(id: UUID) async throws {
    guard let url = URLManager.shared.url(for: ChatEndpoint.leave) else { throw HttpError.badURL }
    let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
    _ = try await NetworkManager.shared.sendJsonData(data, ResponseData.self, to: url)
  }
  
  func findChatRoom(id: UUID) async throws -> ChatRoomData?{
    guard let url = URLManager.shared.url(for: ChatEndpoint.find) else { throw HttpError.badURL }
    let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
    let response = try await NetworkManager.shared.sendJsonData(data, ChatRoomData?.self, to: url)
    return response
  }
  
  func fetchAllChatRooms() async throws {
    guard let url = URLManager.shared.url(for: ChatEndpoint.fetch) else { throw HttpError.badURL }
    self.chatRoomArray = try await NetworkManager.shared.fetchData(to: url, [ChatRoomData].self)
  }
  
  func fetchChats(id: UUID) async throws {
    guard let url = URLManager.shared.url(for: ChatEndpoint.fetchChats) else { throw HttpError.badURL }
    let data = ChatRoomRequestData(chatRoomId: id, userId: MyProfile.id)
    self.messageArray = try await NetworkManager.shared.sendJsonData(data, [Message].self, to: url)
    print(messageArray.count)
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
    return "\(chatRoom.participantIds.count)명 참여중"
  }
}

// MARK: - Message
extension ChatViewModel{
  func sendMessage(_ data: Message){
    WebSocketManager.shared.sendMessage(data)
  }
  
  func receiveMessage(_ data: Message){
    messageArray.append(data)
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

// MARK: - Participants
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
