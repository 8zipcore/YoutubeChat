//
//  ProfileImageView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol ProfileImageViewDelegate{
    func editButtonTapped()
    func profileImageViewTapped()
}

class ProfileImageView: UIView {
    
    var profileImageView = UIImageView()
    var editButton = UIButton()
    var isEditMode: Bool = false {
        didSet{
            editButton.isHidden = !isEditMode
        }
    }
    
    var delegate: ProfileImageViewDelegate?
    
    var isDefaultImage = false

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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        profileImageView.snp.makeConstraints{ make in
            make.width.equalTo(self.bounds.width * 0.8)
            make.height.equalTo(self.bounds.height * 0.8)
        }
        
        editButton.snp.makeConstraints{ make in
            make.width.equalTo(self.bounds.height * 0.3)
            make.height.equalTo(self.bounds.height * 0.3)
        }
        
        profileImageView.layer.cornerRadius = self.bounds.height / 3.2
    }
    
    private func configureView(){
        self.addSubview(profileImageView)
        self.addSubview(editButton)
        
        profileImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().inset(3)
            make.bottom.equalToSuperview().inset(5)
        }
        
        self.backgroundColor = .clear
        
        profileImageView.clipsToBounds = true
        
        // profileImageView.backgroundColor = Colors.skyBlue
        
        editButton.setImage(UIImage(named: "camera_icon"), for: .normal)

        editButton.addTarget(self, action: #selector(editButtonTouchUp(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTouchDown(_:)), for: .touchDown)
        
        editButton.isHidden = !isEditMode
        
        profileImageView.isUserInteractionEnabled = true
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped(_:)))
        profileImageView.addGestureRecognizer(tapGestrue)
        
        setImage(nil)
    }
    
    func image() -> UIImage?{
        return self.profileImageView.image
    }
    
    func setImage(_ image: UIImage){
        self.profileImageView.image = image
        isDefaultImage = false
    }
    
    func setImage(_ imageURLString: String?){
        if let imageURLString = imageURLString, imageURLString.count > 0 {
            let url = URL(string: imageURLString)
            self.profileImageView.kf.setImage(with: url)
            isDefaultImage = false
        } else {
            self.profileImageView.image = UIImage(named: "default_profile")
            isDefaultImage = true
        }
    }
    
    func alert(_ presentImagePickerViewController: @escaping () -> Void) -> UIAlertController{
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            presentImagePickerViewController()
        }))
        alert.addAction(UIAlertAction(title: "기본 이미지 적용", style: .default, handler: { _ in
            self.setImage(nil)
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
    
    @objc
    func profileImageViewTapped(_ sender: UITapGestureRecognizer){
        if isEditMode {
            return
        }
        delegate?.profileImageViewTapped()
    }
}
