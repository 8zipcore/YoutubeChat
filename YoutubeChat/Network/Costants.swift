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
