//
//  RequestData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/22/24.
//

import Foundation

struct EnterChatRequestData: Codable{
    var enterCode: String
    var userID: UUID
}

struct EnterChatRoomData: Codable{
    var chatRoomID: UUID
    var userID: UUID
}
