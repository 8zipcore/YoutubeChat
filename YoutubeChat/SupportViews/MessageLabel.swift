//
//  ChatTextLabel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

class MessageLabel: UIView {
    
    var label = SDGothicLabel()
    
    let topSpacing: CGFloat = 7
    let bottomSpacing: CGFloat = 15
    let horizontalSpacing: CGFloat = 10
    
    var isMyChat: Bool = false
    
    var text: String{
        return label.text ?? ""
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
        self.addSubview(label)
        
        label.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(topSpacing)
            if isMyChat{
                make.trailing.equalToSuperview().inset(horizontalSpacing)
            } else {
                make.leading.equalToSuperview().inset(horizontalSpacing)
            }
            make.width.lessThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(1000)
        }
        
        label.setLabel(textColor: .white, fontSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        self.backgroundColor = isMyChat ? RGB(red: 49, green: 132, blue: 246) : UIColor(white: 1, alpha: 0.15)
        self.layer.cornerRadius = 10
    }
    
    func setText(text: String){
        self.label.text = text
    }
    
    func width(text: String)-> CGFloat{
        self.label.text = text
        self.layoutIfNeeded()
        return self.label.bounds.width + (horizontalSpacing * 2)
    }
    
    func height(text: String)-> CGFloat{
        self.label.text = text
        self.layoutIfNeeded()
        return self.label.bounds.height + bottomSpacing
    }
    
//    func height(text: String)-> CGFloat{
//        self.textView.text = text
//        let size = CGSize(width: self.frame.width, height: .infinity)
//        let height = textView.sizeThatFits(size).height
//    }
}
