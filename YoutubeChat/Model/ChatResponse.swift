//
//  ChatResponse.swift
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
