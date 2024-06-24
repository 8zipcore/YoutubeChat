//
//  MakeGroupChatTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit
import SnapKit

class MakeGroupChatTextField: UIView {
    
    var titleLabel = SDGothicLabel()
    var textField = UITextField()
    
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
        self.addSubview(inputView)
        inputView.addSubview(textField)
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
            make.width.equalTo(self.bounds.width * 0.9)
        }
        
        titleLabel.setLabel(textColor: .black, fontSize: 13)

        inputView.backgroundColor = Colors.lightGray
        inputView.layer.cornerRadius = 10
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
        
        textField.attributedPlaceholder = NSAttributedString(string: "채팅방 이름을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
    }
    
    func setText(title: String, placeHolder: String){
        self.titleLabel.text = title
        self.textField.placeholder = placeHolder
    }
}
