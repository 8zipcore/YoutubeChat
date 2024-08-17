//
//  ChatRoom.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/11/24.
//

import Foundation

struct ChatRoom: Codable{
    var id: UUID?
    var name: String
    var description: String
    var image: String
    var enterCode: String
    var hostId: UUID
    var participantIds: [UUID]
    var chatOptions: [Int]
    var categories: [String]
}

struct ChatRoomData: Codable{
    var id: UUID?
    var name: String
    var description: String
    var image: String
    var enterCode: String
    var hostId: UUID
    var participantIds: [UUID]
    var participants: [User] // 이것이 새로 추가됏다 . . .
    var chatOptions: [Int]
    var categories: [String]
    
    func isOptionContains(_ chatOption: ChatOption) -> Bool{
        return self.chatOptions.contains(chatOption.rawValue)
    }
}
