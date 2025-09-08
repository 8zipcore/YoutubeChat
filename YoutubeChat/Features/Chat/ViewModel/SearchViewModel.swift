//
//  SearchViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/17/24.
//

import Foundation

class SearchViewModel{
  
  var chatRoomArray: [ChatRoomData] = []
  var chatOptionArray = [ChatOptionData(chatOption: .videoAddAllowed)]
  var top5Categories: [CategoryData] = []
  
  func fetchAllChatRooms() async throws {
    guard let url = URLManager.shared.url(for: ChatEndpoint.fetch) else { throw HttpError.badURL }
    self.chatRoomArray = try await NetworkManager.shared.fetchData(to: url, [ChatRoomData].self)
  }
  
  func searchChatRoom(_ text: String, _ chatOptions: [ChatOption]) async throws -> [ChatRoomData]{
    guard let url = URLManager.shared.url(for: ChatEndpoint.search) else { throw HttpError.badURL }
    let searchChatRoomData = SearchChatRoomData(searchTerm: text, chatOptions: chatOptions)
    let response = try await NetworkManager.shared.sendJsonData(searchChatRoomData, [ChatRoomData].self, to: url)
    return response
  }
  
  func fetchChatRooms(_ category: String) async throws -> [ChatRoomData]{
    guard let url = URLManager.shared.url(for: CategoryEndpoint.fetchByCategory) else { throw HttpError.badURL }
    let response = try await NetworkManager.shared.sendJsonData(category, [ChatRoomData].self, to: url)
    return response
  }
  
  func selectedChatOptionArray() -> [ChatOption]{
    return chatOptionArray.filter({$0.isSelected}).map{
      return $0.chatOption
    }
  }
  
  func fetchCategories() async throws -> [String]{
    guard let url = URLManager.shared.url(for: CategoryEndpoint.categories) else { throw HttpError.badURL }
    let response = try await NetworkManager.shared.fetchData(to: url, [String].self)
    return response
  }
  
  func setTop5Categories(_ categories: [String]){
    top5Categories = []
    categories.forEach{
      top5Categories.append(CategoryData(title: $0))
    }
  }
  
  func resetTop5CategoriesSelection(){
    for i in top5Categories.indices{
      top5Categories[i].isSelected = false
    }
  }
}
