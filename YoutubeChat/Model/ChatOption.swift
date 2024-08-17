//
//  ChatOptionData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import Foundation

enum ChatOption: Int, Codable{
    case anonymous
    case videoAddDenied
    case privateRoom
}

struct ChatOptionData: Codable{
    var chatOption: ChatOption
    var title: String{
        switch chatOption{
        case .anonymous:
            return "익명으로 들어가기"
        case .videoAddDenied:
            return "방장만 영상 추가"
        case .privateRoom:
            return "비공개 방"
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
