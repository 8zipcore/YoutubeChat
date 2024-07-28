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
    static let createChat = "chat/create"
    static let enterCode = "chat/entercode"
    static let fetchChat = "chat/"
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
    case createChat
    case enterCode
    case fetchChat
}

class URLManager {
    static let shared = URLManager()
    
    func url(_ type: URLType, _ parameter: String?)-> URL?{
        switch type{
        case .join:
            return URL(string: Constants.baseURL + Endpoints.join)
        case .createChat:
            return URL(string: Constants.baseURL + Endpoints.createChat)
        case .enterCode:
            return URL(string: Constants.baseURL + Endpoints.enterCode)
        case .fetchChat:
            return URL(string: Constants.baseURL + Endpoints.fetchChat + parameter!)
        }
    }
}

