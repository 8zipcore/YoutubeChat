//
//  ProfileInfoViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/16/24.
//

import UIKit

class ProfileInfoViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    enum ImageType{
        case profile, background
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
    
    private var imagePicker = UIImagePickerController()
    private var imageEditViewController = EditImageViewController()
    
    private var profileViewModel = ProfileViewModel()
    
    private var imageType: ImageType?
    
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
        
        backgroundImageView.contentMode = .scaleAspectFill
        let backgroundImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundImageViewTapped(_:)))
        backgroundImageView.addGestureRecognizer(backgroundImageViewTapGestureRecognizer)
        
        profileEditButton.setButton(UIImage(named: "edit_icon"), "프로필 편집")
        let profileEditButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileEditButtonTapped(_:)))
        profileEditButton.addGestureRecognizer(profileEditButtonTapGestureRecognizer)
        
        profileImageView.delegate = self
        imageEditViewController.delegate = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        imageEditViewController.modalPresentationStyle = .fullScreen
        imageEditViewController.delegate = self

        editTopBarView.frame = topBarView.frame
        self.view.addSubview(editTopBarView)
        
        setMyProfile()
        setEditMode(false)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileEditButtonTapped(_ sender: UITapGestureRecognizer){
        setEditMode(true)
    }
    
    @IBAction func editCancelButtonTapped(_ sender: Any) {
        setEditMode(false)
        setMyProfile()
    }
    
    @IBAction func editEndedButtonTapped(_ sender: Any) {
        setEditMode(false)
        Task{
            let user = User(id: MyProfile.id,
                            name: nameLabel.text ?? "",
                            description: descriptionLabel.text ?? "",
                            image: profileImageView.imageToString(),
                            backgroundImage: backgroundImageView.imageToString())
            let response = try await profileViewModel.updateProfile(user: user)
            try await profileViewModel.setUser(response)
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
        self.present(vc, animated: true)
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
        
        backgroundImageView.isUserInteractionEnabled = isEdit
    }
    
    private func setMyProfile(){
        nameLabel.text = MyProfile.name
        descriptionLabel.text = MyProfile.description
        profileImageView.setImage(MyProfile.image ?? UIImage())
        backgroundImageView.image = MyProfile.backgroundImage
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
    func editButtonTapped() {
        imageType = .profile
        presentAlert()
    }
    
    @objc func backgroundImageViewTapped(_ sender: UITapGestureRecognizer){
        imageType = .background
        presentAlert()
    }
    
    private func presentAlert(){
        let title = imageType == .profile ? "프로필 사진 설정" : "배경 사진 설정"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            self.present(self.imagePicker, animated: true)
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
            imagePicker.pushViewController(imageEditViewController, animated: false)
        }
    }
}

extension ProfileInfoViewController: EditImageViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true)
        guard let image = image else { return }
        profileImageView.setImage(image)
    }
}
