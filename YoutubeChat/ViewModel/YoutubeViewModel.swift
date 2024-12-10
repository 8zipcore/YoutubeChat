//
//  YoutubeViewModel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/4/24.
//

import Foundation

class YoutubeViewModel{
    
    static let shared = YoutubeViewModel()

    var videoArray: [Video] = []
    
    func fetchVideos(_ chatRoomId: UUID, _ completion: @escaping () -> Void) async throws {
        guard let url = URLManager.shared.url(.fetchVideos) else { throw HttpError.badURL }
        self.videoArray = try await NetworkManager.shared.sendJsonData(FetchVideoRequestData(chatRoomId: chatRoomId, userId: MyProfile.id), [Video].self, to: url)
        self.videoArray = sortVideoArray(videoArray)
        completion()
    }
    
    func updateStartTime(_ chatRoomId: UUID, _ id: UUID) async throws{
        guard let url = URLManager.shared.url(.updateStartTime) else { throw HttpError.badURL }
        let startTime = Date().timeIntervalSince1970
        self.videoArray[0].startTime = startTime
        print("😉 start Time : \(startTime)")
        let response = try await NetworkManager.shared.sendJsonData(StartVideoRequestData(chatRoomId: chatRoomId, videoId: id, startTime: startTime), ResponseData.self, to: url)
        switch response.responseCode{
        case .success:
            print("✅ update 성공")
        case .failure:
            print("🌀 update 실패")
        }
    }
    
    func deleteVideo(_ chatRoomId: UUID, _ id: UUID) async throws{
        guard let url = URLManager.shared.url(.deleteVideo) else { throw HttpError.badURL }
        var newVideoArray = try await NetworkManager.shared.sendJsonData(DeleteVideoRequestData(chatRoomId: chatRoomId, videoId: id, isEnded: false), [Video].self, to: url)
        newVideoArray = sortVideoArray(newVideoArray)
        NotificationCenter.default.post(name: .deleteVideo, object: nil, userInfo: ["VideoArray": newVideoArray])
    }
    
    func setVideoArray(_ videoArray: [Video]){
        self.videoArray = videoArray
    }
    
    func resetVideoArray(){
        self.videoArray = []
    }
    
    private func sortVideoArray(_ videoArray: [Video]) -> [Video]{
        var videoArray = videoArray
        videoArray.sort{ $0.uploadTime < $1.uploadTime }
        return videoArray
    }
}
