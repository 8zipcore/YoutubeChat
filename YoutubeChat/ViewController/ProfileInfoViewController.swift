//
//  ProfileInfoViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/16/24.
//

import UIKit
import SnapKit

class ProfileInfoViewController: BaseViewController, UIImagePickerControllerDelegate{

    enum ImageType{
        case profile, background
    }
    
    enum ViewType{
        case create, myProfile, userProfile
    }
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet var editTopBarView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: ProfileImageView!

    @IBOutlet weak var nameLabel: SDGothicLabel!
    @IBOutlet weak var descriptionLabel: SDGothicLabel!

    @IBOutlet weak var profileEditButton: ImageButton!
    
    @IBOutlet var lineViewArray: [UIView] = []
    @IBOutlet var editButtonArray: [UIButton] = []
    
    private var imagePickerController: UIImagePickerController?
    private var imageEditViewController = EditImageViewController()
    
    private var profileViewModel = ProfileViewModel()
    
    private var imageType: ImageType?
    
    var viewType: ViewType?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.setLabel(textColor: .white, fontSize: 18)
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.setLabel(textColor: .white, fontSize: 15)
        
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.contentMode = .scaleAspectFill
        let backgroundImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundImageViewTapped(_:)))
        backgroundImageView.addGestureRecognizer(backgroundImageViewTapGestureRecognizer)
        
        profileEditButton.setButton(UIImage(named: "edit_icon"), "프로필 편집")
        let profileEditButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileEditButtonTapped(_:)))
        profileEditButton.addGestureRecognizer(profileEditButtonTapGestureRecognizer)
        
        profileImageView.delegate = self
                
        setImagePickerController()
        imageEditViewController.modalPresentationStyle = .fullScreen
        imageEditViewController.delegate = self
        
        self.view.addSubview(editTopBarView)
        
        editTopBarView.snp.makeConstraints{ make in
            make.edges.equalTo(self.topBarView)
        }
        
        setProfile()
        
        switch viewType {
        case .create:
            setEditMode(true)
        case .myProfile:
            setEditMode(false)
        case .userProfile:
            setEditMode(false)
            profileEditButton.isHidden = true
        case nil:
            break
        }
    }
    
    private func setImagePickerController(){
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.allowsEditing = false
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        if self.navigationController == nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    @objc func profileEditButtonTapped(_ sender: UITapGestureRecognizer){
        setEditMode(true)
    }
    
    @IBAction func editCancelButtonTapped(_ sender: Any) {
        setEditMode(false)
        setProfile()
    }
    
    @IBAction func editEndedButtonTapped(_ sender: Any) {
        guard let user = user else { print("🌀 user data is nil "); return }
        Task{
            let user = UserData(id: user.id!.uuidString,
                                name: nameLabel.text ?? "",
                                description: descriptionLabel.text ?? "",
                                image: profileImageView.isDefaultImage ? nil :
                                    profileImageView.image()?.toJpgData(),
                                backgroundImage: backgroundImageView.image?.toJpgData())
            let response = try await profileViewModel.updateProfile(user: user)
            try await profileViewModel.setUser(response)
            
            DispatchQueue.main.async{
                self.setEditMode(false)
            }
        }
    }
    
    @IBAction func editButtonArrayTapped(_ sender: UIButton) {
        let vc = EditProfileTextViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        if editButtonArray[0] == sender{
            vc.text = nameLabel.text ?? ""
            vc.viewType = .name
        } else if editButtonArray[1] == sender{
            vc.text = descriptionLabel.text ?? ""
            vc.viewType = .description
        }
        self.present(vc, animated: false)
    }
    
    private func setEditMode(_ isEdit: Bool){
        topBarView.isHidden = isEdit
        editTopBarView.isHidden = !isEdit
        
        profileImageView.isEditMode = isEdit
        
        profileEditButton.isHidden = isEdit
        
        lineViewArray.forEach{
            $0.isHidden = !isEdit
        }
        
        editButtonArray.forEach{
            $0.isHidden = !isEdit
        }
    }
    
    private func isEditMode()-> Bool{
        return topBarView.isHidden ? true : false
    }
    
    private func setProfile(){
        guard let user = user else { print("🌀 user data is nil "); return }
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        profileImageView.setImage(user.image)
        backgroundImageView.setImage(imageURLString: user.backgroundImage)
    }
    
    private func presentImageViewController(_ image: UIImage?){
        let vc = ImageViewController()
        vc.image = image
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension ProfileInfoViewController: EditProfileTextViewControllerDelegate{
    func didEndEdit(_ text: String, _ type: EditProfileTextViewController.ViewType) {
        switch type{
        case .name:
            self.nameLabel.text = text
        case .description:
            self.descriptionLabel.text = text
        }
    }
}

extension ProfileInfoViewController: ProfileImageViewDelegate{
    func profileImageViewTapped() {
        presentImageViewController(profileImageView.image())
    }
    
    func editButtonTapped() {
        imageType = .profile
        presentAlert()
    }
    
    @objc func backgroundImageViewTapped(_ sender: UITapGestureRecognizer){
        if isEditMode(){
            imageType = .background
            presentAlert()
        } else {
            if let image = backgroundImageView.image{
                presentImageViewController(image)
            }
        }
    }
    
    private func presentAlert(){
        let title = imageType == .profile ? "프로필 사진 설정" : "배경 사진 설정"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            self.present(self.imagePickerController!, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "기본 이미지 적용", style: .default, handler: { _ in
            switch self.imageType {
            case .profile:
                self.profileImageView.setImage(nil)
            case .background:
                self.backgroundImageView.image = nil
            case .none:
                break
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
}

extension ProfileInfoViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageEditViewController.pickedImage = pickedImage
            imageEditViewController.imageType = imageType
            imageEditViewController.settingFlag = false
            imagePickerController?.present(imageEditViewController, animated: false)
        }
    }
}

extension ProfileInfoViewController: EditImageViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true, completion: {
            self.setImagePickerController()
        })
        
        guard let image = image else { return }
        switch self.imageType {
        case .profile:
            profileImageView.setImage(image)
        case .background:
            self.backgroundImageView.image = image
        case .none:
            break
        }
        
    }
}
