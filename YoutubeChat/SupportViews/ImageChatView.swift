//
//  ImageChatView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/28/24.
//

import Foundation
import SnapKit

class ImageChatView: UIView{
    
    var imageView = UIImageView()
    
    var image: UIImage?{
        return self.imageView.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView(){
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 15
        self.imageView.contentMode = .scaleAspectFill
        
        self.backgroundColor = .clear
    }
    
    func setImage(image: UIImage?){
        self.imageView.image = image
    }
}
