//
//  ChatData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/27/24.
//

import Foundation

enum MessageType:Int, Codable{
    case text, image, addVideo, deleteVideo, enter, leave, reconnect
}

struct Message: Codable{
    var id: UUID?
    var chatRoomId: UUID
    var senderId: UUID
    var messageType: MessageType
    var text: String = ""
    var timestamp: Double = -1
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatRoomId = "chatroom_id"
        case senderId = "sender_id"
        case messageType = "type"
        case text
        case timestamp
    }
}
