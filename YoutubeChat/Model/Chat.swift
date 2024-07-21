//
//  ChatInf.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/11/24.
//

import Foundation

struct Chat: Codable{
    var id: UUID?
    var chatName: String
    var chatImage: String
    var hostID: UUID
    var participantID: [UUID]
    var chatOption: [Int]
}
