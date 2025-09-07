//
//  ImageView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import UIKit
import Kingfisher

extension UIImageView{
  func setCornerRadius(){
    self.layer.cornerRadius = (self.bounds.height * 0.8) / 2.5
  }

  func setImage(imageURLString: String){
    let url = URL(string: imageURLString)
    self.kf.setImage(with: url)
  }
  
  func setImageWithDefault(imageURLString: String){
    if imageURLString.count == 0 {
      self.image = UIImage(named: "default_profile")
    } else {
      setImage(imageURLString: imageURLString)
    }
  }
}

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
