//
//  ChatOptionData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import Foundation

enum ChatOption: Int, Codable{
    case videoAddDenied
    case searchAllowed
    case password
}

struct ChatOptionData: Codable{
    var chatOption: ChatOption
    var title: String{
        switch chatOption{
        case .videoAddDenied:
            return "방장만 영상 추가"
        case .searchAllowed:
            return "검색 허용"
        case .password:
            return "비밀번호"
        }
    }
    var isSelected: Bool
    
    mutating func toggle(){
        isSelected.toggle()
    }
    
    init(chatOption: ChatOption){
        self.chatOption = chatOption
        self.isSelected = false
    }
}
