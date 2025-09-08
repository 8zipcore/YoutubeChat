//
//  NetworkConfig.swift
//  YoutubeChat
//
//  Created by 홍승아 on 9/8/25.
//

import Foundation

enum Constant{
  case local
  case render
  
  var domain: String {
    switch self {
    case .local:
      return "localhost:8080"
    case .render:
      return "youtubechatsever.onrender.com"
    }
  }
  
  var baseURL: String {
    switch self {
    case .local:
      return "http://\(domain)"
    case .render:
      return "https://\(domain)"
    }
  }
  
  var websocketURL: URL? {
    var urlString = ""
    
    switch self {
    case .local:
      urlString = "ws"
    case .render:
      urlString = "wss"
    }
    
    urlString += "://\(self.domain)/chat/message"
    
    return URL(string: urlString)
  }
}

protocol APIEndpoint {
    var rawValue: String { get }
}

enum UserEndpoint: String, APIEndpoint {
  case join = "/user/join"
  case update = "/user/update"
}

enum ChatEndpoint: String, APIEndpoint {
  case fetch = "/chat/fetch"
  case create = "/chat/create"
  case update = "/chat/update"
  case uploadImage = "/chat/uploadImage"
  case enterCode = "/chat/entercode"
  case enter = "/chat/enter"
  case leave = "/chat/leave"
  case quit = "/chat/quit"
  case find = "/chat/find"
  case search = "/chat/search"
  case fetchChats = "/chat/fetchChats"
  case fetchVideos = "/chat/fetchVideos"
  case updateStartTime = "/chat/updateStartTime"
  case deleteVideo = "/chat/deleteVideo"
}

enum CategoryEndpoint: String, APIEndpoint {
  case categories = "/category/fetch"
  case fetchByCategory = "/category/fetchChatRooms"
}
