//
//  View.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import UIKit

extension UIScrollView{
  func scrollToCenter() {
    let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
    setContentOffset(centerOffset, animated: true)
  }
}
