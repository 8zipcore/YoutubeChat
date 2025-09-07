//
//  BaseViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/24/24.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  
  var hideKeyboard = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.delegate = self
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("🟢 \(String(describing: type(of: self)))")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("🔴 \(String(describing: type(of: self)))")
  }
  
  @objc func dismissKeyboard() {
    if hideKeyboard{
      view.endEditing(true)
    }
  }
  
  // 제스처가 다른 터치 이벤트와 함께 작동할 수 있도록 허용
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    var touchedView = touch.view
    
    while touchedView != nil {
      if touchedView is UICollectionViewCell || touchedView is UITableViewCell {
        return false
      }
      
      touchedView = touchedView?.superview
    }
    return true
  }
}
