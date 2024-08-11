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

struct EnterChatResponseData: Codable{
    var responseCode: EnterCodeResponse
    var chatRoom: ChatRoom?
}

enum ResponseCode: Int, Codable{
    case success, failure
}

struct ResponseData: Codable{
    var responseCode: ResponseCode
}

struct AddVideoResponseData: Codable{
    var responseCode: ResponseCode
    var videos: [Video]
}
