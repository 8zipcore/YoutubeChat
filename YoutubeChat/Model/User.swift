//
//  User.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/27/24.
//

import Foundation

struct User: Codable{
    var id: UUID?
    var name: String
    var image: String
    var statusMessage: String
    var chatID: [UUID]
}
