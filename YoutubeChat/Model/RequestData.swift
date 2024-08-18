//
//  RequestData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/22/24.
//

import Foundation

struct EnterChatRequestData: Codable{
    var enterCode: String
    var userId: UUID
}

struct EnterChatRoomData: Codable{
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
