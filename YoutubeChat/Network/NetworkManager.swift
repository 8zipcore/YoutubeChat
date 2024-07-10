//
//  NetworkManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation
import Alamofire

class NetworkManager{
    static let sahred = NetworkManager()
    
    func sendData<T:Codable>(to url: URL, resultType: T.Type, params: [String:Any]) async throws -> T {
        let request = AF.request(url, method: .post, parameters: params)
        let dataTask = request.serializingDecodable(resultType)
        
        switch await dataTask.result{
        case .success(let data):
            return data
        case .failure(let error):
            throw HttpError.badResponse
        }
    }

}
