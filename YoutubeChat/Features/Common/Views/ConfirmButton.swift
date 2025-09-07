//
//  ConfirmButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/21/24.
//

import UIKit

class ConfirmButton: UIButton {
  
  // 비율 986:154
  // 크기 superView.width * 0.88
  
  override var isHighlighted: Bool {
    get {
      return super.isHighlighted
    }
    set {
      super.isHighlighted = newValue
      backgroundColor = isHighlighted ? Colors.blue.withAlphaComponent(0.8) : Colors.blue
    }
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
    self.backgroundColor = Colors.blue
    self.setAttributedTitle(
      NSMutableAttributedString(
        string: "완료",
        attributes: [.foregroundColor : UIColor.white,
                     .font : SDGothicSemiBold(size: 18)]),
      for: .normal)
    self.layer.cornerRadius = 10
  }
  
  func setTitle(_ string: String){
    self.setAttributedTitle(
      NSMutableAttributedString(
        string: string,
        attributes: [.foregroundColor : UIColor.white,
                     .font : SDGothicSemiBold(size: 18)]),
      for: .normal)
  }
  
  func showLoading() {
    self.setTitle("")
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.color = .white
    activityIndicator.tag = 999 // 나중에 제거할 때 사용할 태그
    activityIndicator.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    
    activityIndicator.startAnimating()
    
    addSubview(activityIndicator)
    
    isEnabled = false
  }
  
  func hideLoading() {
    self.setTitle("완료")
    
    if let activityIndicator = viewWithTag(999) as? UIActivityIndicatorView {
      activityIndicator.stopAnimating()
      activityIndicator.removeFromSuperview()
    }
    
    isEnabled = true
  }
}
