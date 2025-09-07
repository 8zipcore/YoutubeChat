//
//  SystemChatTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/26/24.
//

import UIKit
import SnapKit

class SystemChatTableViewCell: UITableViewCell {
  
  static let identifier = "SystemChatTableViewCell"
  
  var label = SDGothicLabel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    initView()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initView(){
    self.addSubview(label)
    
    label.snp.makeConstraints{ make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
    }
    
    self.backgroundColor = .clear
    
    label.setLabel(textColor: .white, fontSize: 13)
    label.textAlignment = .center
    label.numberOfLines = 0
  }
  
  func configureView(_ text: String){
    self.label.text = text
  }
  
  func height(_ text: String) -> CGFloat{
    self.configureView(text)
    self.layoutIfNeeded()
    return self.label.bounds.height + 6
  }
  
}
