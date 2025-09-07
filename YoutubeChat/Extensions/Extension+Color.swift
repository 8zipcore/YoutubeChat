//
//  Extension+Color.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/19/24.
//

import UIKit

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: alpha
    )
  }
}
