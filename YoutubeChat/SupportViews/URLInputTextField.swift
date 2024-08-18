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
    
    enum ViewType{
        case url, search
    }

    var textField = UITextField()
    var addButton = UIButton()
    
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
                imageName = "plus"
                placeHolder = "검색"
            case .none:
                break
            }
            addButton.setImage(UIImage(named: imageName), for: .normal)
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
    
    func configureView(){
        self.addSubview(textField)
        self.addSubview(addButton)
        
        textField.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }
        
        addButton.snp.makeConstraints{ make in
            make.leading.equalTo(textField.snp.trailing).inset(-10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.height * 0.6)
            make.height.equalTo(self.bounds.height * 0.6)
        }
        
        self.backgroundColor = Colors.lightGray
        self.layer.cornerRadius = self.bounds.height / 2
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
        textField.delegate = self
        
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped(_:))))
    }
    
    @objc func addButtonTapped(_ sender: UITapGestureRecognizer){
        // guard let button = sender.view as? UIButton else { return }
        delegate?.addButtonTapped?()
    }
    
    func hideKeyboard(){
        textField.resignFirstResponder()
    }
}

extension URLInputTextField: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count  == 0{
            return
        }
        delegate?.textFieldDidChange?(textField.text!)
    }
}

