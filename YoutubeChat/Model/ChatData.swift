//
//  ChatData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/27/24.
//

import Foundation

enum MessageType:Int, Codable{
    case text, image, video, join, leave
}

struct ChatData: Codable{
    var id: UUID?
    var groupChatID: UUID
    var senderID: UUID
    var messageType: MessageType
    var message: String
    var image: String
    var timestamp: TimeInterval
}
