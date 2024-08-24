//
//  BaseViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/24/24.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    // 키보드 내리기 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 제스처가 다른 터치 이벤트와 함께 작동할 수 있도록 허용
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchedView = touch.view
        
        while touchedView != nil {
            // 터치된 뷰 또는 그 상위 뷰가 UICollectionViewCell인지 확인
            if touchedView is UICollectionViewCell || touchedView is UITableViewCell {
                return false
            }
            // 슈퍼뷰로 이동
            touchedView = touchedView?.superview
        }
        return true
    }
}
