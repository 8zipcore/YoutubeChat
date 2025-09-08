//
//  Extension+Notification.Name.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/18/24.
//

import Foundation

extension Notification.Name {
  static let receiveMessage = Notification.Name("receiveMessage")
  static let receiveAddVideo = Notification.Name("receiveAddVideo")
  static let receiveDeleteVideo = Notification.Name("receiveDeleteVideo")
  static let updatePlaylistVC = Notification.Name("pdatePlaylistVC")
  static let reconnected = Notification.Name("reconnected")
  static let receiveParticipant = Notification.Name("receiveParticipant")
  static let updateChatRoom = Notification.Name("updateChatRoom")
}
