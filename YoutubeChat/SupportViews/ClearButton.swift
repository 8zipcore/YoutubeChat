//
//  ClearButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/29/24.
//

import UIKit

protocol ClearButtonDelegate{
    func clearButtonTapped()
}

class ClearButton: UIButton {
    
    var delegate: ClearButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        self.setImage(UIImage(named: "gray_xmark"), for: .normal)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
        self.isHidden = true
    }
    
    @objc func buttonTapped(_ sender: UITapGestureRecognizer){
        delegate?.clearButtonTapped()
    }
}
