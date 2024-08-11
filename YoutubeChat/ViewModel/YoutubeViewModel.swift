//
//  YoutubeViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/4/24.
//

import Foundation

class YoutubeViewModel{

    var videoArray: [Video] = []
    
    func fetchVideos(_ chatRoomId: UUID, _ completion: @escaping () -> Void) async throws {
        guard let url = URLManager.shared.url(.fetchVideos) else { throw HttpError.badURL }
        self.videoArray = try await NetworkManager.shared.sendJsonData(FetchVideoRequestData(chatRoomId: chatRoomId, userId: MyProfile.id), [Video].self, to: url)
        completion()
    }
    
    func updateStartTime(_ chatRoomId: UUID, _ videoId: String) async throws{
        guard let url = URLManager.shared.url(.updateStartTime) else { throw HttpError.badURL }
        let startTime = Date().timeIntervalSince1970
        self.videoArray[0].startTime = startTime
        print("😉 start Time : \(startTime)")
        let response = try await NetworkManager.shared.sendJsonData(StartVideoRequestData(chatRoomId: chatRoomId, videoId: videoId, startTime: startTime), ResponseData.self, to: url)
        switch response.responseCode{
        case .success:
            print("✅ update 성공")
        case .failure:
            print("🌀 update 실패")
        }
    }
    
    func deleteVideo(_ chatRoomId: UUID, _ startTime: Double) async throws{
        guard let url = URLManager.shared.url(.deleteVideo) else { throw HttpError.badURL }
        let response = try await NetworkManager.shared.sendJsonData(DeleteVideoRequestData(chatRoomId: chatRoomId, startTime: startTime), ResponseData.self, to: url)
        switch response.responseCode{
        case .success:
            print("✅ delete 성공")
        case .failure:
            print("🌀 delete 실패")
        }
    }
}
