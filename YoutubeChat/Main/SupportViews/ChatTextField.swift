//
//  ChatTextField.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

class ChatTextField: UIView {
    
    let textField = UITextField()
    
    var text: String{
        return self.textField.text ?? ""
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
        self.addSubview(textField)
        
        textField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.9)
            make.height.equalTo(self.bounds.height * 0.9)
        }
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.bounds.height / 3
        self.clipsToBounds = true
        
        textField.font = SDGothic(size: 15)
        textField.textColor = .black
        textField.tintColor = Colors.gray
    }
}
