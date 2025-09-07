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
  var description: String
  var image: String
  var backgroundImage: String
}

struct UserData: Codable{
  var id: String
  var name: String
  var description: String
  var image: Data?
  var backgroundImage: Data?
}
