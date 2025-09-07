//
//  ChatTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

protocol ChatTextViewDelegate{
  func setChatTextViewHeight(_ height: CGFloat)
  func sendButtonTapped()
}

class ChatTextView: UIView {
  
  let textView = UITextView()
  var sendButton = UIButton()
  var delegate: ChatTextViewDelegate?
  
  private var lineCount: CGFloat = 0
  private var maxLineCount: CGFloat = 4
  
  private var isInitView = false
  
  var text: String{
    return self.textView.text
  }
  
  var isBlank: Bool {
    return self.textView.text.count == 0
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if !isInitView{
      let sendButtonWidth = self.bounds.height * 0.9
      sendButton.snp.makeConstraints{ make in
        make.bottom.equalToSuperview().inset(self.bounds.height * 0.1)
        make.width.equalTo(sendButtonWidth)
        make.height.equalTo(sendButtonWidth)
      }
      
      self.layer.cornerRadius = self.bounds.height / 2
      
      isInitView = true
    }
  }
  
  private func configureView(){
    self.addSubview(sendButton)
    self.addSubview(textView)
    
    textView.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(5)
    }
    
    sendButton.snp.makeConstraints{ make in
      make.leading.equalTo(textView.snp.trailing).offset(5)
      make.trailing.equalToSuperview().inset(5)
    }
    
    self.backgroundColor = UIColor(white: 1, alpha: 0.2)
    self.clipsToBounds = true
    
    textView.font = .sdGothic(size: 15)
    textView.textColor = .white
    textView.tintColor = Colors.gray
    textView.delegate = self
    textView.backgroundColor = .clear
    
    sendButton.setImage(UIImage(named: "send_icon"), for: .normal)
    sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendButtonTapped(_:))))
    
    self.layoutIfNeeded()
  }
  
  func estimatedHeight()-> CGFloat{
    let size = CGSize(width: self.textView.bounds.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    return estimatedSize.height
  }
  
  func lineHeight() -> CGFloat{
    let minHeight: CGFloat = 10
    return self.textView.font?.lineHeight ?? minHeight
  }
  
  func resetText(){
    self.textView.text = ""
  }
  
  func hideKeyboard(){
    self.textView.resignFirstResponder()
  }
  
  @objc func sendButtonTapped(_ sender: UITapGestureRecognizer){
    self.delegate?.sendButtonTapped()
  }
}

extension ChatTextView: UITextViewDelegate{
  func textViewDidChange(_ textView: UITextView) {
    var height = estimatedHeight()
    
    if let lineHeight = textView.font?.lineHeight {
      let maxLineHeight = textView.textContainerInset.top + textView.textContainerInset.bottom + (lineHeight * maxLineCount)
      if height > maxLineHeight {
        height = maxLineHeight
      }
    }
    
    self.delegate?.setChatTextViewHeight(height)
  }
}
