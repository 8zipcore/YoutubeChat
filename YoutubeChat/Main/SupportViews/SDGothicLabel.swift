//
//  SDGothicLabel.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/14/24.
//

import UIKit

class SDGothicLabel: UILabel {
    
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
        configureView()
    }
    
    private func configureView(){
        self.setLetterSpacing(0.4)
        self.setLineSpacing(0.2)
        self.setLineBreakMode()
    }
    
    func setLabel(textColor: UIColor, fontSize: Int){
        self.textColor = textColor
        self.font = SDGothic(size: fontSize)
    }
}
