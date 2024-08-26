//
//  URLInputTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/31/24.
//

import UIKit
import SnapKit

@objc protocol URLInputTextFieldDelegate{
    @objc optional func buttonTapped()
    @objc optional func textFieldDidChange(_ text: String)
}

class URLInputTextField: UIView {
    
    enum ViewType{
        case url, search
    }

    var textField = UITextField()
    var button = UIButton()
    
    private var buttonWidthMultiplier: CGFloat = 0.6
    
    var text: String{
        return textField.text ?? ""
    }
    
    var isBlank: Bool{
        return textField.text?.count == 0
    }
    
    var type: ViewType?{
        didSet{
            var imageName = ""
            var placeHolder = ""
            switch type {
            case .url:
                imageName = "plus"
                placeHolder = "유튜브 url을 입력해주세요."
            case .search:
                imageName = "gray_xmark"
                placeHolder = "검색"
                buttonWidthMultiplier = 0.4
                button.isHidden = true
            case .none:
                break
            }
            button.setImage(UIImage(named: imageName), for: .normal)
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
        }
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
        
        self.backgroundColor = Colors.lightGray
        self.layer.cornerRadius = self.bounds.height / 2
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
        textField.delegate = self
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
    }
    
    @objc func buttonTapped(_ sender: UITapGestureRecognizer){
        // guard let button = sender.view as? UIButton else { return }
        delegate?.buttonTapped?()
    }
    
    func hideKeyboard(){
        textField.resignFirstResponder()
    }
    
    func setText(_ text: String){
        self.textField.text = text
    }
}

extension URLInputTextField: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChange?(textField.text!)
    }
}

