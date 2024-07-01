//
//  ProfileImageView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

class ProfileImageView: UIView {
    
    var profileImageView = UIImageView()
    var editButton = UIButton()

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
        self.addSubview(profileImageView)
        self.addSubview(editButton)
        
        profileImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.8)
            make.height.equalTo(self.bounds.height * 0.8)
        }
        
        editButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileImageView.layer.cornerRadius = self.bounds.height / 3.2
        profileImageView.clipsToBounds = true
        
        profileImageView.image = UIImage(named: "rikus")
        editButton.setTitle("편집", for: .normal)
        editButton.backgroundColor = .black
    }
    
}