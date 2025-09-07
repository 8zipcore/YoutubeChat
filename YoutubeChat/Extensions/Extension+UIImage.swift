//
//  Extension+UIImage.swift
//  YoutubeChat
//
//  Created by 홍승아 on 9/7/25.
//

import UIKit

extension UIImage {
  func resizedImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let ratio = min(widthRatio, heightRatio)
    
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
    self.draw(in: CGRect(origin: .zero, size: newSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage ?? self
  }
  
  func toJpgData() -> Data?{
    return self.jpegData(compressionQuality: 0.8)
  }
}
