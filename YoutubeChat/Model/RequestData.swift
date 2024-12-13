//
//  RequestData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/22/24.
//

import Foundation

struct EnterChatRoomData: Codable{
    var chatRoomId: UUID
    var enterCode: String
    var userId: UUID
}

struct ChatRoomRequestData: Codable{
    var chatRoomId: UUID
    var userId: UUID
}

struct FetchVideoRequestData: Codable{
    var chatRoomId: UUID
    var userId: UUID
}

struct AddVideoRequestData: Codable{
    var chatRoomId: UUID
    var userId: UUID
    var url: String
}

struct StartVideoRequestData: Codable{
    var chatRoomId: UUID
    var videoId: UUID
    var startTime: Double
}

struct DeleteVideoRequestData: Codable{
    var chatRoomId: UUID
    var videoId: UUID
}

struct SearchChatRoomData: Codable{
    var searchTerm: String
    var chatOptions: [ChatOption]
}

struct ImageAndMetaData: Codable {
    var parameters: [String : String]
    var imageDataSet: [String : Data]
}

struct ChatRoomWithImageData: Codable{
    var id: String?
    var name: String
    var description: String
    var image: String
    var enterCode: String
    var hostId: String
    var participantIds: [String]
    var allParticipantIds: [String]
    var chatOptions: [String]
    var categories: [String]
    var lastChatTime: String
    var imageData: Data?
}
