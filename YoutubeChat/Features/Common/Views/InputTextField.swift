//
//  InputTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit
import SnapKit

@objc protocol InputTextFieldDelegate{
  @objc optional func textFieldTextDidChange(_ sender: InputTextField)
  @objc optional func textFieldDidBeginEditing(_ sender: InputTextField)
}

class InputTextField: UIView, ClearButtonDelegate {
  
  // 비율 986:213
  // 크기 superView.width * 0.88
  
  var titleLabel = SDGothicLabel()
  var textField = UITextField()
  var lengthLabel = SDGothicLabel()
  var clearButton = ClearButton()
  var contentView = UIView()
  
  var maxLength = -1
  
  var delegate: InputTextFieldDelegate?
  
  var text: String{
    return self.textField.text ?? ""
  }
  
  var textCount: Int{
    return self.textField.text?.count ?? 0
  }
  
  var placeHolder: String{
    return self.textField.placeholder ?? ""
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
      make.width.equalTo(self.bounds.width * 0.05)
      make.height.equalTo(self.bounds.width * 0.05)
    }
  }
  
  private func configureView(){
    self.backgroundColor = .clear
    
    self.addSubview(titleLabel)
    self.addSubview(lengthLabel)
    self.addSubview(contentView)
    contentView.addSubview(textField)
    contentView.addSubview(clearButton)
    
    titleLabel.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    lengthLabel.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.trailing.equalToSuperview()
      make.centerY.equalTo(titleLabel)
    }
    
    contentView.snp.makeConstraints{ make in
      make.top.equalTo(titleLabel.snp.bottom).inset(-5)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(self.bounds.height * 0.7)
    }
    
    textField.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(13)
    }
    
    clearButton.snp.makeConstraints{ make in
      make.leading.equalTo(textField.snp.trailing).inset(-5)
      make.trailing.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    titleLabel.setLabel(textColor: .white, fontSize: 13)
    lengthLabel.setLabel(textColor: Colors.gray, fontSize: 13)
    
    contentView.backgroundColor = Colors.backgroundWhite
    contentView.layer.cornerRadius = 10
    contentView.layer.borderColor = Colors.borderGray.cgColor
    contentView.layer.borderWidth = 1.5
    
    textField.font = .sdGothic(size: 15)
    textField.textColor = .white
    textField.tintColor = Colors.gray
    textField.delegate = self
    textField.backgroundColor = .clear
    
    textField.attributedPlaceholder = NSAttributedString(string: "채팅방 이름을 입력해주세요.",
                                                         attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
    
    textField.autocorrectionType = .no
    textField.spellCheckingType = .no
    
    clearButton.delegate = self
  }
  
  func setText(title: String, placeHolder: String){
    self.titleLabel.text = title
    self.textField.placeholder = placeHolder
  }
  
  func setText(title: String, placeHolder: String, maxLength: Int){
    self.titleLabel.text = title
    self.textField.placeholder = placeHolder
    self.lengthLabel.text = "0/\(maxLength)"
    self.maxLength = maxLength
  }
  
  func setText(_ text: String){
    self.textField.text = text
    if maxLength > 0 {
      self.lengthLabel.text = "\(text.count)/\(maxLength)"
    }
  }
  
  func setPlaceHolder(_ placeHolder: String){
    self.textField.placeholder = placeHolder
  }
  
  func setLengthLabel(){
    if maxLength != -1 {
      lengthLabel.text = "\(textField.text?.count ?? 0)/\(maxLength)"
    }
  }
  
  func showAnimation(){
    UIView.animate(withDuration: 0.07, animations: {
      self.textField.transform = CGAffineTransform(translationX: -2, y: 0)
    }, completion: { _ in
      UIView.animate(withDuration: 0.07, animations: {
        self.textField.transform = CGAffineTransform(translationX: 4, y: 0)
      }, completion: { _ in
        UIView.animate(withDuration: 0.07, animations: {
          self.textField.transform = .identity
        }, completion: { _ in
          
        })
      })
    })
  }
  
  func isBlank()-> Bool{
    return textCount == 0
  }
  
  func showKeyboard(){
    self.textField.becomeFirstResponder()
  }
  
  func hideKeyboard(){
    textField.resignFirstResponder()
  }
  
  func clearButtonTapped(){
    self.textField.text = ""
    self.textField.sendActions(for: .editingChanged)
  }
}

extension InputTextField: UITextFieldDelegate{
  func textFieldDidChangeSelection(_ textField: UITextField) {
    clearButton.isHidden = !(textField.text?.count ?? 0 > 0)
    setLengthLabel()
    delegate?.textFieldTextDidChange?(self)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    
    return maxLength != -1 ? updatedText.count <= maxLength : true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.contentView.backgroundColor = UIColor(white: 1, alpha: 0.15)
    delegate?.textFieldDidBeginEditing?(self)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.contentView.backgroundColor = Colors.backgroundWhite
  }
}
