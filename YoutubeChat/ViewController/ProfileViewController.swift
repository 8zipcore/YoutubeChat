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
    @IBOutlet weak var nameTextField: MakeGroupChatTextField!
    
    private var imagePicker = UIImagePickerController()
    private var imageEditViewController = ImageEditViewController()
    
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
    }
    
}

extension ProfileViewController: ProfileImageViewDelegate{
    func editButtonTapped() {
        self.present(imagePicker, animated: true)
    }
}

extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageEditViewController.pickedImage = pickedImage
            
            imagePicker.pushViewController(imageEditViewController, animated: false)
            // self.present(imageEditViewController, animated: false)
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
