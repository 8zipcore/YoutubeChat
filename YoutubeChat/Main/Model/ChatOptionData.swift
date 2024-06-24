//
//  ChatOptionData.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import Foundation

struct ChatOptionData{
    var title: String
    var isSelected: Bool
    
    mutating func toggle(){
        isSelected.toggle()
    }
}
