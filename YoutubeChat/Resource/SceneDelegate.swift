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
      DeepLinkManager.handleDeeplink(url: url)
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
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    DeepLinkManager.handleDeeplink(url: url)
  }
}
