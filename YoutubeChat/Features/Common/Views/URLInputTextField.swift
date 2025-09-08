//
//  URLInputTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/31/24.
//

import UIKit
import SnapKit

@objc protocol URLInputTextFieldDelegate{
  @objc optional func addButtonTapped()
  @objc optional func textFieldDidChange(_ text: String)
}

class URLInputTextField: UIView {
  
  var textField = UITextField()
  var button = UIButton()
  
  private var buttonWidthMultiplier: CGFloat = 0.6
  
  var text: String{
    return textField.text ?? ""
  }
  
  var isBlank: Bool{
    return textField.text?.count == 0
  }
  
  var delegate: URLInputTextFieldDelegate?
  
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
    button.snp.makeConstraints{ make in
      make.width.equalTo(self.bounds.height * buttonWidthMultiplier)
      make.height.equalTo(self.bounds.height * buttonWidthMultiplier)
    }
  }
  
  func configureView(){
    self.addSubview(textField)
    self.addSubview(button)
    
    textField.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(15)
    }
    
    button.snp.makeConstraints{ make in
      make.leading.equalTo(textField.snp.trailing).inset(-10)
      make.trailing.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    self.backgroundColor = .init(white: 1, alpha: 0.2)
    self.layer.cornerRadius = self.bounds.height / 2
    
    textField.font = .sdGothic(size: 15)
    textField.textColor = .white
    textField.tintColor = Colors.gray
    textField.delegate = self
    
    button.setImage(UIImage(named:"plus_icon"), for: .normal)
    textField.attributedPlaceholder = NSAttributedString(string:"유튜브 url을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
    
    button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
  }
  
  @objc func buttonTapped(_ sender: UITapGestureRecognizer){
    delegate?.addButtonTapped?()
  }
  
  func hideKeyboard(){
    textField.resignFirstResponder()
  }
  
  func setText(_ text: String){
    self.textField.text = text
  }
  
  func resetText(){
    self.textField.text = ""
  }
  
  func buttonEnabled(_ value: Bool){
    self.button.isUserInteractionEnabled = value
  }
}

extension URLInputTextField: UITextFieldDelegate{
  func textFieldDidChangeSelection(_ textField: UITextField) {
    delegate?.textFieldDidChange?(textField.text!)
  }
}

