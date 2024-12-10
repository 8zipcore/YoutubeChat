//
//  ProfileViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import UIKit

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate{

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var nameTextField: InputTextField!
    @IBOutlet weak var confirmButton: ConfirmButton!
    
    private var imagePickerController: UIImagePickerController?
    private var imageEditViewController = EditImageViewController()
    
    private let profileViewModel = ProfileViewModel()
    
    private var isDefaultImage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView(){
        self.view.backgroundColor = .black
        
        titleLabel.setLabel(textColor: .white, fontSize: 17)
        titleLabel.text = "프로필 설정"
        nameTextField.setText(title: "이름", placeHolder: "이름을 입력하세요.")
        
        profileImageView.delegate = self
        profileImageView.isEditMode = true
        
        setImagePickerController()
        
        imageEditViewController.modalPresentationStyle = .fullScreen
        imageEditViewController.delegate = self
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if nameTextField.isBlank(){
            nameTextField.showAnimation()
        } else {
            confirmButton.showLoading()
            Task{
                let user = User(id: nil,
                                name: nameTextField.text,
                                description: "",
                                image: profileImageView.isDefaultImage ? "" : profileImageView.imageToString(),
                                backgroundImage: "")
                let response = try await profileViewModel.createProfile(user:user)
                try await profileViewModel.setUser(response)
                
                DispatchQueue.main.async {
                    self.presentMainViewController()
                    self.confirmButton.hideLoading()
                }
            }
        }
    }
    
    private func presentMainViewController(){
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    private func setImagePickerController(){
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.allowsEditing = false
    }
}
                                                            
extension ProfileViewController: ProfileImageViewDelegate{
    func profileImageViewTapped() {
        let vc = ImageViewController()
        vc.image = profileImageView.image
        self.present(vc, animated: true)
    }
    
    func editButtonTapped() {
        let alert = self.profileImageView.alert { self.present(self.imagePickerController!, animated: true) }
        self.present(alert, animated: true)
    }
}

extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageEditViewController.pickedImage = pickedImage
            imageEditViewController.imageType = .profile
            imagePickerController?.present(imageEditViewController, animated: false)
        }
    }
}

extension ProfileViewController: EditImageViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true, completion: {
            self.setImagePickerController()
        })
                     
        guard let image = image else { return }
        profileImageView.setImage(image)
    }
}
