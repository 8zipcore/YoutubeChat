//
//  ImageView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/10/24.
//

import UIKit

extension UIImageView{
    func setCornerRadius(){
        self.layer.cornerRadius = (self.bounds.height * 0.8) / 2.5
    }
    
    func imageToString() -> String{
        guard let image = self.image, let imageData = image.pngData()  else { return "" }
        return imageData.base64EncodedString()
    }
    
    func setImage(imageString: String){
        if let imageData = Data(base64Encoded: imageString){
            self.image = UIImage(data: imageData)
        }
    }
    
    func setImageWithDefault(imageString: String){
        if let imageData = Data(base64Encoded: imageString),
           let image = UIImage(data: imageData){
            self.image = image
        } else {
            self.image = UIImage(named: "default_profile")
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
}
