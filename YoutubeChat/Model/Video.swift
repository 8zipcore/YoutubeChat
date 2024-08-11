//
//  Video.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import Foundation

struct Video: Codable{
    var id: String
    var userID: UUID
    var title: String
    var uploader: String
    var thumbnail: String
    var duration: Double
    var startTime: Double
    var endTime: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title
        case uploader
        case thumbnail
        case duration
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
