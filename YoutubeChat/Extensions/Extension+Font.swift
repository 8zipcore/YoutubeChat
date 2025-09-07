//
//  Extension+Font.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/13/24.
//

import UIKit

extension UIFont {
  enum FontWeight {
    case regular
    case semiBold
    case bold
  }
  
  static func sdGothic(size: Int, weight: FontWeight = .regular) -> UIFont{
    switch weight {
    case .regular:
      return UIFont(name: "Apple SD Gothic Neo", size: CGFloat(size))!
    case .semiBold:
      return UIFont(name: "Apple SD Gothic Neo SemiBold", size: CGFloat(size))!
    case .bold:
      return UIFont(name: "Apple SD Gothic Neo Bold", size: CGFloat(size))!
    }
  }
}
