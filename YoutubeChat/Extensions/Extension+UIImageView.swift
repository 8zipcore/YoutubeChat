//
//  Extension+UIImageView.swift
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
