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
}
