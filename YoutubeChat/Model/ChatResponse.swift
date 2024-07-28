//
//  ChatResponse.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/21/24.
//

import Foundation

enum EnterCodeResponse: Int, Codable{
    case invalidCode, validCode
}

struct EnterChatResponseData: Codable{
    var respone: EnterCodeResponse
    var chat: Chat?
}
