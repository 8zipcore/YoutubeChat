//
//  ProfileViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/24/24.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var nameTextField: InputTextField!
    
    private var imagePicker = UIImagePickerController()
    private var imageEditViewController = ImageEditViewController()
    
    private let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView(){
        titleLabel.setTitleLabel()
        titleLabel.text = "프로필 설정"
        nameTextField.setText(title: "이름", placeHolder: "이름을 입력하세요.")
        
        profileImageView.delegate = self
        imageEditViewController.delegate = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        imageEditViewController.modalPresentationStyle = .fullScreen
        imageEditViewController.delegate = self
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if nameTextField.isBlank(){
            nameTextField.showAnimation()
        } else {
            print("✅ 클릭")
            Task{
                let user = User(id: nil,
                                name: nameTextField.text,
                                image: profileImageView.imageToString(),
                                statusMessage: "",
                                chatID: [])
                let response = try await profileViewModel.createProfile(user:user)
                try await profileViewModel.setUser(response)
                
                DispatchQueue.main.async {
                    self.presentMainViewController()
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
}
                                                            
extension ProfileViewController: ProfileImageViewDelegate{
    func editButtonTapped() {
        let alert = self.profileImageView.alert { self.present(self.imagePicker, animated: true) }
        self.present(alert, animated: true)
    }
}

extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageEditViewController.pickedImage = pickedImage
            imagePicker.pushViewController(imageEditViewController, animated: false)
        }
    }
}

extension ProfileViewController: ImageEditViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true)
        guard let image = image else { return }
        profileImageView.setImage(image)
    }
}