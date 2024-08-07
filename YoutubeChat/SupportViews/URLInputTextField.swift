//
//  URLInputTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/31/24.
//

import UIKit
import SnapKit

protocol URLInputTextFieldDelegate{
    func addButtonTapped()
}

class URLInputTextField: UIView {

    var textField = UITextField()
    var addButton = UIButton()
    
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
        }
        
        self.backgroundColor = Colors.lightGray
        self.layer.cornerRadius = self.bounds.height / 2
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
        textField.attributedPlaceholder = NSAttributedString(string: "유튜브 url을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped(_:))))
    }
    
    @objc func addButtonTapped(_ sender: UITapGestureRecognizer){
        // guard let button = sender.view as? UIButton else { return }
        delegate?.addButtonTapped()
    }
    
    func hideKeyboard(){
        textField.resignFirstResponder()
    }
}


