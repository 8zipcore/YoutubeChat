//
//  TransitionAnimation.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/28/24.
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let toViewFrame = toView.view.bounds
        let fromViewFrame = fromView.view.bounds
        
        toView.view.frame = CGRect(x: toViewFrame.width, y: 0, width: toViewFrame.width, height: toViewFrame.height)
        
        transitionContext.containerView.insertSubview(toView.view, aboveSubview: fromView.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.view.frame = CGRect(x: 0, y: 0, width: toViewFrame.width, height: toViewFrame.height)
                fromView.view.frame =  CGRect(x: -fromViewFrame.width, y: 0, width: fromViewFrame.width, height: fromViewFrame.height)
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
}

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let toViewFrame = toView.view.bounds
        let fromViewFrame = fromView.view.bounds
        
        toView.view.frame = CGRect(x: -fromViewFrame.width, y: 0, width: toViewFrame.width, height: toViewFrame.height)
        
        transitionContext.containerView.insertSubview(toView.view, aboveSubview: fromView.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.view.frame = CGRect(x: 0, y: 0, width: toViewFrame.width, height: toViewFrame.height)
                fromView.view.frame =  CGRect(x: fromViewFrame.width, y: 0, width: fromViewFrame.width, height: fromViewFrame.height)
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
}


