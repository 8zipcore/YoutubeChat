//
//  NetworkManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    func sendJsonData<T: Codable>(_ data: T, to url: URL) async throws -> T{
        guard let jsonData = try? JSONEncoder().encode(data) else {
            throw JsonError.encoding
        }
//        print("✅ 전송 Data")
//        debugPrint(data)
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(jsonData, to: url, method: .post, headers: ["Content-Type": "application/json"])
                .responseDecodable(of: T.self){ response in
                    switch response.result{
                    case .success(let data):
                        print("⭐️ 성공")
//                        debugPrint("✅ 수신 Data")
//                        dump(data)
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchData<T: Codable>(to url: URL) async throws -> T {
        return await withCheckedContinuation{ continuation in
            AF.request(url, method: .get)
                .responseDecodable(of: T.self){ response in
                    switch response.result{
                    case .success(let data):
                        print("⭐️ 성공")
//                        debugPrint("✅ 수신")
//                        dump(data)
                        continuation.resume(returning: data)
                    case .failure(let error):
                        print("🌀 수신 Error : \(error)")
                        // continuation.resume(throwing: error)
                    }
                }
        }
    }

}
