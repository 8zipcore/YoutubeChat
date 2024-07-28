//
//  ChatData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/27/24.
//

import Foundation

enum MessageType:Int, Codable{
    case text, image, video, enter, leave
}

struct Message: Codable{
    var id: UUID?
    var groupChatID: UUID
    var senderID: UUID
    var messageType: MessageType
    var text: String = ""
    var image: String?
    var timestamp: TimeInterval?
    var isRead: Bool
}
