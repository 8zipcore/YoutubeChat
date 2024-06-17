//
//  NSAttributedString.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/13/24.
//

import UIKit

extension UILabel{
    func setLetterSpacing(_ spacing: CGFloat){
        let text = self.text ?? ""
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.kern,
                                        value: spacing,
                                      range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
    }
    
    func setLineSpacing(_ spacing: CGFloat){
        let text = self.text ?? ""
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
    func setLineBreakMode(){
        let text = self.text ?? ""
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
