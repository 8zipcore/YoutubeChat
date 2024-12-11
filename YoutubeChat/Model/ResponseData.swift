//
//  ResponseData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/21/24.
//

import Foundation

enum EnterCodeResponse: Int, Codable{
    case invalidCode, validCode, existing
}

enum ResponseCode: Int, Codable{
    case success, failure
}

enum EnterChatRoomResponseCode: Int, Codable{
    case success, failure, invalid
}

enum SendDataType: Int, Codable{
    case message, addVideo, deleteVideo, participant
}

struct EnterChatResponseData: Codable{
    var responseCode: EnterCodeResponse
    var chatRoom: ChatRoomData?
}

struct ResponseData: Codable{
    var responseCode: ResponseCode
}

struct VideoResponseData: Codable{
    var responseCode: ResponseCode
    var video: Video?
}

struct SendData: Codable{
    var type: SendDataType
    var data: Data
}

struct ChatRoomResponseData: Codable{
    var responseCode: EnterChatRoomResponseCode
    var chatRoom: ChatRoomData?
}

struct ParticipantData: Codable {
    var type: MessageType
    var user: User
}
