//
//  BaseNavigationController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/28/24.
//

import UIKit

class BaseNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            switch operation{
            case .none:
                return nil
            case .push:
                return PushAnimation()
            case .pop:
                return PopAnimation()
            @unknown default:
                return nil
            }
        }
}
