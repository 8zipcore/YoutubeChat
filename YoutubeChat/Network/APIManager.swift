//
//  APIManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import Foundation
import Alamofire

enum YoutubeAPI{
    static let baseURL = "https://youtube.googleapis.com/youtube/v3/videos"
    static let apiKey = ""
}

class APIManager{
    
    static let shared = APIManager()
    
    func fetchVideo(id: String, onComplete: @escaping (Result<Video, Error>) -> Void) async throws {
        guard let url = URL(string: YoutubeAPI.baseURL) else { onComplete(.failure(HttpError.badURL)); return }
        let params = ["part" : "snippet",
                      "id": id,
                      "key": YoutubeAPI.apiKey]
        AF.request(url, method: .get, parameters: params)
            .responseData{ response in
                switch response.result{
                case .success(let data):
                    do{
                        guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] else { throw JsonError.decoding }
                        var video = Video(title: "", uploader: "", thumbnail: "")
                        if let items = json["items"] as? [[String:Any]]{
                            if items.count > 0, let item = items[0]["snippet"] as? [String:Any]{
                                video.title = item["title"] as? String ?? "-"
                                video.uploader = item["channelTitle"] as? String ?? "-"
                                if let thumbnails = item["thumbnails"] as? [String:Any]{
                                    if let thumbnail = thumbnails["medium"] as? [String:Any]{
                                        video.thumbnail = thumbnail["url"] as? String ?? "-"
                                    }
                                }
                            }
                        }
                        onComplete(.success(video))
                    } catch {
                        onComplete(.failure(JsonError.decoding))
                    }
                case .failure(let error):
                    onComplete(.failure(HttpError.badResponse))
                    debugPrint("🌀 \(error)")
                }
            }
    }
}
