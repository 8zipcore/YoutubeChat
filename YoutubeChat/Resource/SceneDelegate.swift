//
//  SceneDelegate.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.overrideUserInterfaceStyle = .light
    let rootViewController = ProfileManager.shared.isSavedID() ? MainViewController() : ProfileViewController()
    ProfileManager.shared.setUser()
    let navigationViewController = BaseNavigationController(rootViewController: rootViewController)
    navigationViewController.navigationBar.isHidden = true
    window.rootViewController = navigationViewController
    window.makeKeyAndVisible()
    self.window = window
    
    if let url = connectionOptions.urlContexts.first?.url {
      handleDeeplink(url: url)
    }
    
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    WebSocketManager.shared.connect()
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    WebSocketManager.shared.disconnect()
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
  }
}

extension SceneDelegate{
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    
    handleDeeplink(url: url)
    
  }
  
  private func handleDeeplink(url: URL) {
    if url.scheme == "BeChat" {
      let path = url.path
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
      
      // 예시: myapp://profile?user_id=123
      if path == "/chatInfo", let id = queryItems?.first(where: { $0.name == "id" })?.value {
        print("🐬 id  ! ! : \(id)")
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

