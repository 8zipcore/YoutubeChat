//
//  ChatTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

protocol ChatTextViewDelegate{
    func setChatTextViewHeight(_ height: CGFloat)
}

class ChatTextView: UIView {
    
    let textView = UITextView()
    var chatTextViewHeightDelegate: ChatTextViewDelegate?
    private var lineCount: CGFloat = 0
    private var maxLineCount: CGFloat = 5
    
    var text: String{
        return self.textView.text
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
        self.addSubview(textView)
        
        textView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.bounds.height / 3
        self.clipsToBounds = true
        
        textView.font = SDGothic(size: 15)
        textView.textColor = .black
        textView.tintColor = Colors.gray
        
        textView.delegate = self
    }
    
    func estimatedHeight()-> CGFloat{
        let size = CGSize(width: self.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        return estimatedSize.height
    }
    
    func resetText(){
        self.textView.text = ""
    }
}

extension ChatTextView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        var height = estimatedHeight()
        if let lineHeight = textView.font?.lineHeight{
            if height > lineHeight * maxLineCount{
                height = lineHeight * maxLineCount
            }
        }
        self.chatTextViewHeightDelegate?.setChatTextViewHeight(height)
    }
}
