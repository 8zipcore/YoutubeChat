//
//  Costants.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation

enum Constants{
    static let baseURL = "http://127.0.0.1:8080/"
}

enum Endpoints {
    static let join = "join"
    static let update = "update"
    
    static let fetch = "chat/fetch"
    static let create = "chat/create"
    static let enterCode = "chat/entercode"
    static let enter = "chat/enter"
    static let leave = "chat/leave"
    static let quit = "chat/quit"
    static let find = "chat/find"
    
    // Youtube 관련
    static let fetchVideos = "chat/fetchVideos"
    static let updateStartTime = "chat/updateStartTime"
    static let deleteVideo = "chat/deleteVideo"
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
    case enterCode
    case enter
    case leave
    case quit
    case find
    case fetchVideos
    case updateStartTime
    case deleteVideo
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
        case .fetchVideos:
            return URL(string: Constants.baseURL + Endpoints.fetchVideos)
        case .updateStartTime:
            return URL(string: Constants.baseURL + Endpoints.updateStartTime)
        case .deleteVideo:
            return URL(string: Constants.baseURL + Endpoints.deleteVideo)
        }
    }
}

