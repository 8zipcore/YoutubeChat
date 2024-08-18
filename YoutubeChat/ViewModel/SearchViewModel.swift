//
//  SearchViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/17/24.
//

import Foundation

class SearchViewModel{
    
    var chatRoomArray: [ChatRoomData] = []
    var chatOptionArray = [ChatOptionData(chatOption: .anonymous),
                           ChatOptionData(chatOption: .videoAddDenied)]
    
    func searchChatRoom(_ text: String, _ chatOptions: [ChatOption]) async throws -> [ChatRoomData]{
        guard let url = URLManager.shared.url(.search) else { throw HttpError.badURL }
        let searchChatRoomData = SearchChatRoomData(searchTerm: text, chatOptions: chatOptions)
        let response = try await NetworkManager.shared.sendJsonData(searchChatRoomData, [ChatRoomData].self, to: url)
        return response
    }
    
    func selectedChatOptionArray() -> [ChatOption]{
        return chatOptionArray.filter({$0.isSelected}).map{
            return $0.chatOption
        }
    }
}
