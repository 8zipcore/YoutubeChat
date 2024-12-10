//
//  NotificationName.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/18/24.
//

import Foundation

extension Notification.Name {
    static let receiveMessage = Notification.Name("receiveMessage")
    static let receiveVideo = Notification.Name("receiveVideo")
    static let reconnected = Notification.Name("reconnected")
    static let deleteVideo = Notification.Name("deleteVideo")
}
