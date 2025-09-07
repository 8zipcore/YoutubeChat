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
            print("🌀 실패 : \(error)")
            continuation.resume(throwing: error)
          }
        }
    }
  }
  
  func sendJsonData<T1: Codable, T2: Codable>(_ requestData: T1,_ reponseData: T2.Type, to url: URL) async throws -> T2{
    guard let jsonData = try? JSONEncoder().encode(requestData) else {
      throw JsonError.encoding
    }
    //        print("✅ 전송 Data")
    //        debugPrint(data)
    return try await withCheckedThrowingContinuation { continuation in
      AF.upload(jsonData, to: url, method: .post, headers: ["Content-Type": "application/json"])
        .responseDecodable(of: T2.self){ response in
          switch response.result{
          case .success(let data):
            print("⭐️ 성공")
            //                        debugPrint("✅ 수신 Data")
            //                        dump(data)
            continuation.resume(returning: data)
          case .failure(let error):
            debugPrint("🌀 error : \(error)")
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
          }
        }
    }
  }
  
  func fetchData<T: Codable>(to url: URL, _ dataType: T.Type) async throws -> T{
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(url, method: .get)
        .responseDecodable(of: T.self){ response in
          switch response.result{
          case .success(let data):
            print("⭐️ 성공")
            continuation.resume(returning: data)
          case .failure(let error):
            print("🌀 실패 : \(error)")
            continuation.resume(throwing: error)
          }
        }
    }
  }
  
  func sendImageAndMetadata<T: Codable>(to url: URL, _ uploadData: ImageAndMetaData, _ dataType: T.Type) async throws -> T {
    let parameters = uploadData.parameters
    
    return try await withCheckedThrowingContinuation { continuation in
      AF.upload(multipartFormData: { multipartFormData in
        for (key, value) in parameters {
          multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
        }
        let _ = uploadData.imageDataSet.map{
          let data = $0.value
          let name = $0.key
          multipartFormData.append(data, withName: name, mimeType: "image/jpg")
        }
      }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data"])
      .responseDecodable(of: T.self){ response in
        switch response.result{
        case .success(let data):
          print("⭐️ 성공")
          continuation.resume(returning: data)
        case .failure(let error):
          print("🌀 실패 : \(error)")
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
