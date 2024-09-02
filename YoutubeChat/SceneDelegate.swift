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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
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
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        WebSocketManager.shared.connect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        WebSocketManager.shared.disconnect()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate{
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          guard let url = URLContexts.first?.url else { return }
          
        handleDeeplink(url: url)
 
      }
      
      private func handleDeeplink(url: URL) {
          if url.scheme == "BeChat" {
              // URL path 및 query를 분석하여 적절한 화면으로 전환
              let path = url.path
              let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
              
              // 예시: myapp://profile?user_id=123
              if path == "/chatInfo", let id = queryItems?.first(where: { $0.name == "id" })?.value {
                  print("🐬 id  ! ! : \(id)")
                  let vc = ChatRoomInfoViewController()
                  vc.id = UUID(uuidString: id)
                  
                  // SceneDelegate를 통해 현재의 윈도우를 찾기
                   if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                       if let rootVC = scene.windows.first?.rootViewController {
                           // 네비게이션 컨트롤러를 통해 푸시
                           if let navController = rootVC as? UINavigationController {
                               navController.pushViewController(vc, animated: true)
                           } else {
                               // 네비게이션 컨트롤러가 없으면 모달로 표시
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

