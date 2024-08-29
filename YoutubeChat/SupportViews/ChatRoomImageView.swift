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
    
    var overlayView = UIView()
    var chatRoomImageView = UIImageView()
    var editImageView = UIImageView()
    
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
        self.addSubview(overlayView)
        self.addSubview(editImageView)
        
        chatRoomImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.8)
            make.height.equalTo(self.bounds.height * 0.8)
        }
        
        overlayView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.8)
            make.height.equalTo(self.bounds.height * 0.8)
        }
        
        editImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self.bounds.width * 0.2)
            make.height.equalTo(self.bounds.width * 0.2)
        }
        
        overlayView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        let editImage = UIImage(named: "edit_image_icon")?.withRenderingMode(.alwaysTemplate)
        editImageView.image = editImage
        editImageView.tintColor = .white
        
        chatRoomImageView.contentMode = .scaleAspectFill
        chatRoomImageView.clipsToBounds = true

        chatRoomImageView.layer.cornerRadius = 20
        overlayView.layer.cornerRadius = self.bounds.height * 0.08
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editViewTapped(_:)))
        overlayView.addGestureRecognizer(tapGesture)
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
    func editViewTapped(_ sender: UITapGestureRecognizer){
        self.delegate?.editButtonTapped()
    }
    
    func imageToString()-> String{
        return self.chatRoomImageView.imageToString()
    }
    
}
