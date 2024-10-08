//
//  ChatOptionData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import Foundation

enum ChatOption: Int, Codable{
    case videoAddAllowed
    case searchAllowed
    case password
}

struct ChatOptionData: Codable{
    var chatOption: ChatOption
    var title: String{
        switch chatOption{
        case .videoAddAllowed:
            return "동영상 추가 허용"
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
