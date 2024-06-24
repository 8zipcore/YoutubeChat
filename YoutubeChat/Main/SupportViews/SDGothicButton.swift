//
//  SDGothicButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit

class SDGothicButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
        attributedString.addAttribute(.font, value: SDGothicSemiBold(size: 35), range: NSRange(location: 0, length: attributedString.length))
        self.titleLabel?.attributedText = attributedString
        
        self.tintColor = .black
    }

}
