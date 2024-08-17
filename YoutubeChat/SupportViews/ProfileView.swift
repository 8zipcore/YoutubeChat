//
//  ProfileView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    var profileImageView = UIImageView()
    var nameLabel = SDGothicLabel()
    var messageLabel = SDGothicLabel()
    
    override func awakeFromNib() {
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
        addSubViews()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = (self.bounds.height * 0.8) / 2.5
        
        nameLabel.setLabel(textColor: .black, fontSize: 15)
        
        messageLabel.setLabel(textColor: .gray, fontSize: 12)
        messageLabel.textAlignment = .right
    }
    
    private func addSubViews(){
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(messageLabel)
        
        let width = self.bounds.width
        let height = self.bounds.height
        let verticalSpacing = self.bounds.height * 0.1
        let horizontalSpacing = self.bounds.width * 0.05
        
        profileImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(verticalSpacing)
            make.bottom.equalToSuperview().inset(verticalSpacing)
            make.leading.equalToSuperview().inset(horizontalSpacing)
            make.width.equalTo(height * 0.8)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        let messageLabelWidth = width * 0.4
        
        messageLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(horizontalSpacing)
            make.width.equalTo(messageLabelWidth)
        }
    }
    
    func setImage(_ image: UIImage?){
        self.profileImageView.image = image
    }
    
    func setName(_ name: String){
        self.nameLabel.text = name
    }
    
    func setDescription(_ description: String){
        self.messageLabel.text = description
    }
    
    func setMyProfile(){
        setImage(MyProfile.image)
        setName(MyProfile.name)
        setDescription(MyProfile.description)
    }
}
