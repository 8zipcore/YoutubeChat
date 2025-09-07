//
//  SDGothicLabel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/14/24.
//

import UIKit

class SDGothicLabel: UILabel {
  
  enum FontStyle{
    case semibold, bold
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
    configureView()
  }
  
  private func configureView(){
    self.setLetterSpacing(0.4)
    self.setLineSpacing(0.2)
    self.setLineBreakMode()
  }
  
  func setLabel(textColor: UIColor, fontSize: Int){
    self.textColor = textColor
    self.font = SDGothic(size: fontSize)
  }
  
  func setLabel(textColor: UIColor, fontStyle: FontStyle, fontSize: Int){
    self.textColor = textColor
    switch fontStyle{
    case .semibold:
      self.font = SDGothicSemiBold(size: fontSize)
    case .bold:
      self.font = SDGothicBold(size: fontSize)
    }
  }
}
