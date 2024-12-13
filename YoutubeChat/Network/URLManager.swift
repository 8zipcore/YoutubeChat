//
//  Costants.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation

enum Constants{
    static let domain = "1d51-175-114-118-140.ngrok-free.app"
//    static let baseURL = "https://youtubechatsever.onrender.com/"
    static let baseURL = "https://\(domain)"
}

enum Endpoints {
    static let join = "/user/join"
    static let update = "/user/update"
    
    static let fetch = "/chat/fetch"
    static let create = "/chat/create"
    static let updateChatRoom = "/chat/update"
    static let uploadChatRoomImage = "/chat/uploadImage"
    static let enterCode = "/chat/entercode"
    static let enter = "/chat/enter"
    static let leave = "/chat/leave"
    static let quit = "/chat/quit"
    static let find = "/chat/find"
    static let search = "/chat/search"
    
    static let fetchChats = "/chat/fetchChats"
    
    static let categories = "/category/fetch"
    static let fetchByCategory = "/category/fetchChatRooms"
    
    // Youtube 관련
    static let fetchVideos = "/chat/fetchVideos"
    static let updateStartTime = "/chat/updateStartTime"
    static let deleteVideo = "/chat/deleteVideo"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

enum JsonError: Error {
    case encoding, decoding;
}

enum MIMEType: String{
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum URLType{
    case join
    case update
    case fetch
    case create
    case updateChatRoom
    case uploadChatRoomImage
    case enterCode
    case enter
    case leave
    case quit
    case find
    case search
    case categories
    case fetchByCategory
    case fetchVideos
    case updateStartTime
    case deleteVideo
    case fetchChats
}

class URLManager {
    static let shared = URLManager()
    
    func url(_ type: URLType, _ parameter: String = "")-> URL?{
        switch type{
        case .join:
            return URL(string: Constants.baseURL + Endpoints.join)
        case .update:
            return URL(string: Constants.baseURL + Endpoints.update)
        case .fetch:
            return URL(string: Constants.baseURL + Endpoints.fetch)
        case .create:
            return URL(string: Constants.baseURL + Endpoints.create)
        case .updateChatRoom:
            return URL(string: Constants.baseURL + Endpoints.updateChatRoom)
        case .uploadChatRoomImage:
            return URL(string: Constants.baseURL + Endpoints.uploadChatRoomImage)
        case .enterCode:
            return URL(string: Constants.baseURL + Endpoints.enterCode)
        case .enter:
            return URL(string: Constants.baseURL + Endpoints.enter)
        case .leave:
            return URL(string: Constants.baseURL + Endpoints.leave)
        case .quit:
            return URL(string: Constants.baseURL + Endpoints.quit)
        case .find:
            return URL(string: Constants.baseURL + Endpoints.find)
        case .search:
            return URL(string: Constants.baseURL + Endpoints.search)
        case .categories:
            return URL(string: Constants.baseURL + Endpoints.categories)
        case .fetchByCategory:
            return URL(string: Constants.baseURL + Endpoints.fetchByCategory)
        case .fetchVideos:
            return URL(string: Constants.baseURL + Endpoints.fetchVideos)
        case .updateStartTime:
            return URL(string: Constants.baseURL + Endpoints.updateStartTime)
        case .deleteVideo:
            return URL(string: Constants.baseURL + Endpoints.deleteVideo)
        case .fetchChats:
            return URL(string: Constants.baseURL + Endpoints.fetchChats)
        }
    }
}

