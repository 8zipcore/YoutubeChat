//
//  ConfirmButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/21/24.
//

import UIKit

class ConfirmButton: UIButton {
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            backgroundColor = isHighlighted ? Colors.pastelBlue.withAlphaComponent(0.9) : Colors.pastelBlue
            
        }
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
        self.backgroundColor = Colors.pastelBlue
        self.setAttributedTitle(
            NSMutableAttributedString(
            string: "완료",
            attributes: [.foregroundColor : Colors.skyBlue,
                         .font : SDGothicSemiBold(size: 18)]),
            for: .normal)
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
