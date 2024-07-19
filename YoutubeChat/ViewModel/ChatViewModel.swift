//
//  ChatViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import Foundation

class ChatViewModel{
    
    var chatOptionArray = [ChatOptionData(chatOption: .anonymous),
                           ChatOptionData(chatOption: .addVideo)]
    
    var myChatArray: [MyChatInfo] = []
    
    func createGroupChat(chatInfo: ChatInfo) async throws -> ChatInfo{
        guard let url = URL(string: Constants.baseURL + Endpoints.createChat) else {
            throw HttpError.badURL
        }
        
        return try await NetworkManager.shared.sendJsonData(chatInfo, to: url)
    }
    
    func saveChatInfo(chatInfo: ChatInfo){
        var myChatInfo = MyChatInfo(chatID: chatInfo.id,
                                    chatName: chatInfo.chatName, 
                                    chatImage: chatInfo.chatImage,
                                    participantNumber: chatInfo.participantID.count,
                                    lastMessage: "",
                                    timestamp: Date())
        CoreDataManager.shared.saveMyChatInfo(myChatInfo)
    }
    
    func fetchChatInfo(){
        self.myChatArray = CoreDataManager.shared.fetchMyChatInfo()
    }
    
    func selectedChatOptions()-> [Int]{
        var selectedChatOptions: [Int] = []
        
        chatOptionArray.forEach{
            if $0.isSelected{
                selectedChatOptions.append($0.chatOption.rawValue)
            }
        }
        
        return selectedChatOptions
    }
    
    func myChatInfoToChatInfo(myChatInfo: MyChatInfo)-> ChatInfo{
        return ChatInfo(id: myChatInfo.chatID, chatName: myChatInfo.chatName, chatImage: myChatInfo.chatImage, hostID: UUID(), participantID: [], chatOption: [])
    }
}
