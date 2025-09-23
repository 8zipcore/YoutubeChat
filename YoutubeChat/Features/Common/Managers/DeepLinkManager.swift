//
//  DeepLinkManager.swift
//  YoutubeChat
//
//  Created by 홍승아 on 9/22/25.
//

import UIKit

final class DeepLinkManager {
  
  static func deepLink(id: UUID) -> String {
    "BeChat://scene/chatInfo?id=\(id.uuidString)"
  }
  
  static func handleDeeplink(url: URL) {
    if url.scheme == "BeChat" {
      let path = url.path
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
      
      if path == "/chatInfo", let id = queryItems?.first(where: { $0.name == "id" })?.value {
        let vc = ChatRoomInfoViewController()
        vc.id = UUID(uuidString: id)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          if let rootVC = scene.windows.first?.rootViewController {
            if let navController = rootVC as? UINavigationController {
              navController.pushViewController(vc, animated: true)
            } else {
              rootVC.present(vc, animated: true, completion: nil)
            }
          } else {
            print("Root View Controller not found")
          }
        }
      }
    }
  }
}
