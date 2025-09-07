//
//  ImageButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/17/24.
//

import UIKit
import SnapKit

class ImageButton: UIView {
  
  let imageView = UIImageView()
  let label = SDGothicLabel()
  
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
    self.backgroundColor = .clear
    
    self.addSubview(imageView)
    self.addSubview(label)
    
    imageView.snp.makeConstraints{ make in
      make.top.equalToSuperview().inset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(self.bounds.width * 0.25)
      make.height.equalTo(self.bounds.width * 0.25)
    }
    
    label.snp.makeConstraints{ make in
      make.top.equalTo(imageView.snp.bottom).inset(-15)
      make.centerX.equalToSuperview()
      make.width.equalTo(self.bounds.width * 0.8)
    }
    
    label.setLabel(textColor: .white, fontSize: 13)
    label.textAlignment = .center
  }
  
  func setButton(_ image: UIImage?, _ title: String){
    self.imageView.image = image
    self.label.text = title
  }
}
