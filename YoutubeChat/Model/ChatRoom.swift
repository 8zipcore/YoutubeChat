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
