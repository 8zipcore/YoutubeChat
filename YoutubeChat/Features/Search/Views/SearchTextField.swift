//
//  SearchTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/29/24.
//

import UIKit
import SnapKit

@objc protocol SearchTextFieldDelegate{
  @objc optional func textFieldDidChange(_ text: String)
}

class SearchTextField: UIView, ClearButtonDelegate {
  
  var imageView = UIImageView()
  var textField = UITextField()
  var clearButton = ClearButton()
  
  private var buttonWidthMultiplier: CGFloat = 0.35
  private var imageViewWidthMultiplier: CGFloat = 0.045
  
  var delegate: SearchTextFieldDelegate?
  
  var text: String{
    return textField.text ?? ""
  }
  
  var isBlank: Bool{
    return textField.text?.count == 0
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
    clearButton.snp.makeConstraints{ make in
      make.width.equalTo(self.bounds.height * buttonWidthMultiplier)
      make.height.equalTo(self.bounds.height * buttonWidthMultiplier)
    }
    
    imageView.snp.makeConstraints{ make in
      make.width.equalTo(self.bounds.width * imageViewWidthMultiplier)
      make.height.equalTo(self.bounds.width * imageViewWidthMultiplier)
    }
  }
  
  func configureView(){
    self.addSubview(imageView)
    self.addSubview(textField)
    self.addSubview(clearButton)
    
    imageView.snp.makeConstraints{ make in
      make.leading.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    textField.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalTo(imageView.snp.trailing).inset(-7)
    }
    
    clearButton.snp.makeConstraints{ make in
      make.leading.equalTo(textField.snp.trailing).inset(-10)
      make.trailing.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    self.backgroundColor = .init(white: 1, alpha: 0.2)
    self.layer.cornerRadius = 10
    
    if let image = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate){
      imageView.image = image
      imageView.tintColor = Colors.gray
    }
    
    textField.font = .sdGothic(size: 15)
    textField.textColor = .white
    textField.tintColor = Colors.gray
    textField.delegate = self
    textField.attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
    
    clearButton.delegate = self
  }
  
  func clearButtonTapped(){
    textField.text = ""
    textField.sendActions(for: .editingChanged)
  }
  
  func hideKeyboard(){
    textField.resignFirstResponder()
  }
  
  func setText(_ text: String){
    self.textField.text = text
  }
}

extension SearchTextField: UITextFieldDelegate{
  func textFieldDidChangeSelection(_ textField: UITextField) {
    clearButton.isHidden = !(textField.text?.count ?? 0 > 0)
    delegate?.textFieldDidChange?(textField.text!)
  }
}
