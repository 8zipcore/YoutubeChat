//
//  ChatOptionData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import Foundation

enum ChatOption: Int, Codable{
    case anonymous
    case addVideo
}

struct ChatOptionData: Codable{
    var chatOption: ChatOption
    var title: String{
        switch chatOption{
        case .anonymous:
            return "익명으로 들어가기"
        case .addVideo:
            return "비디오 추가 허용"
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
