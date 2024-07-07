//
//  SDGothicTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit

class SDGothicTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView(){
        self.attributedText = NSAttributedString(string: self.text, 
                                                 attributes: [ NSAttributedString.Key.kern : 0.4,
                                                               .font : SDGothic(size: 13)])
    }
    
}
