//
//  InputTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit
import SnapKit

protocol InputTextFieldDelegate{
    func textFieldTextDidChange(_ sender: InputTextField)
}

class InputTextField: UIView {
    
    // 비율 986:213
    // 크기 superView.width * 0.88
    
    var titleLabel = SDGothicLabel()
    var textField = UITextField()
    var lengthLabel = SDGothicLabel()
    
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
    
    private func configureView(){
        self.backgroundColor = .clear
        
        let inputView = UIView()

        self.addSubview(titleLabel)
        self.addSubview(lengthLabel)
        self.addSubview(inputView)
        inputView.addSubview(textField)
        
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
        
        inputView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.bounds.height * 0.7)
        }
        
        textField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(13)
            make.trailing.equalToSuperview().inset(13)
        }
        
        
        titleLabel.setLabel(textColor: .black, fontSize: 13)
        lengthLabel.setLabel(textColor: Colors.gray, fontSize: 13)

        inputView.backgroundColor = Colors.lightGray
        inputView.layer.cornerRadius = 10
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
        textField.delegate = self
        
        textField.attributedPlaceholder = NSAttributedString(string: "채팅방 이름을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
        
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
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
    
    func becomeFirstResponder(){
        self.textField.becomeFirstResponder()
    }
}

extension InputTextField: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setLengthLabel()
        delegate?.textFieldTextDidChange(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트 길이
        let currentText = textField.text ?? ""
        // 변경될 텍스트 길이
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // 텍스트 길이 제한 설정
        return maxLength != -1 ? updatedText.count <= maxLength : true
    }
}
