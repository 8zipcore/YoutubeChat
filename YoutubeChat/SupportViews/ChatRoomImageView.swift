//
//  ChatRoomImageView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/4/24.
//

import UIKit
import SnapKit

protocol ChatRoomImageViewDelegate{
    func editButtonTapped()
}

class ChatRoomImageView: UIView {
    
    var chatRoomImageView = UIImageView()
    var editButton = UIButton()
    
    var delegate: ChatRoomImageViewDelegate?
    
    var image: UIImage?{
        return chatRoomImageView.image
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
        self.addSubview(chatRoomImageView)
        self.addSubview(editButton)
        
        chatRoomImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.8)
            make.height.equalTo(self.bounds.height * 0.8)
        }
        
        editButton.snp.makeConstraints{ make in
            make.trailing.equalTo(chatRoomImageView.snp.trailing).inset(3)
            make.bottom.equalTo(chatRoomImageView.snp.bottom).inset(5)
            make.width.equalTo(self.bounds.height * 0.15)
            make.height.equalTo(self.bounds.height * 0.15)
        }
        
        chatRoomImageView.layer.cornerRadius = self.bounds.height / 10
        chatRoomImageView.clipsToBounds = true
        
        chatRoomImageView.backgroundColor = Colors.pastelBlue
        
        if let editButtonImage = UIImage(named: "plus") {
            let rederingImage = editButtonImage.withRenderingMode(.alwaysTemplate)
            editButton.setBackgroundImage(rederingImage, for: .normal)
            editButton.setBackgroundImage(rederingImage, for: .highlighted)
        }
        
        editButton.tintColor = UIColor(white: 0, alpha: 0.8)
        
        editButton.addTarget(self, action: #selector(editButtonTouchUp(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTouchDown(_:)), for: .touchDown)
    }
    
    func setImage(_ image: UIImage){
        self.chatRoomImageView.image = image
    }
    
    func alert(_ presentImagePickerViewController: @escaping () -> Void) -> UIAlertController{
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            presentImagePickerViewController()
        }))
        alert.addAction(UIAlertAction(title: "기본 이미지 적용", style: .default, handler: { _ in
            self.chatRoomImageView.image = nil
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert
    }
    
    @objc
    func editButtonTouchUp(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            self.editButton.tintColor = UIColor(white: 0, alpha: 0.8)
        }, completion: { _ in
            self.delegate?.editButtonTapped()
        })
    }
    
    @objc
    func editButtonTouchDown(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            self.editButton.tintColor = Colors.gray
        })
    }
    
    func imageToString()-> String{
        return self.chatRoomImageView.imageToString()
    }
    
}
