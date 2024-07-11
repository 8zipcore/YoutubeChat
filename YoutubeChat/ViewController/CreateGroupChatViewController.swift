//
//  CreateGroupChatViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit

class CreateGroupChatViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var chatImageView: ProfileImageView!
    @IBOutlet weak var chatNameTextField: InputTextField!
    @IBOutlet weak var chatOptionLabel: SDGothicLabel!
    @IBOutlet weak var chatOptionCollectionView: UICollectionView!
    @IBOutlet weak var chatOptionCollectionViewHeight: NSLayoutConstraint!
    
    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 10
    
    private var imagePicker = UIImagePickerController()
    private var imageEditViewController = ImageEditViewController()
    
    var chatViewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurView()
    }
    
    private func configurView(){
        chatNameTextField.setText(title: "채팅방 이름", placeHolder: "채팅방 이름을 입력해주세요.")
        chatOptionLabel.setLabel(textColor: .black, fontSize: 13)
        
        chatOptionCollectionView.dataSource = self
        chatOptionCollectionView.delegate = self       
        chatOptionCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        imageEditViewController.modalPresentationStyle = .fullScreen
        imageEditViewController.delegate = self
        
        chatImageView.delegate = self
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if chatNameTextField.isBlank(){
            chatNameTextField.showAnimation()
        } else {
            Task{
                let chatInfo = ChatInfo(chatName: chatNameTextField.text,
                                    chatImage: chatImageView.imageToString(),
                                    hostID: MyProfile.id,
                                    participantID: [MyProfile.id],
                                    chatOption: chatViewModel.selectedChatOptions())
                let response = try await chatViewModel.createGroupChat(chatInfo: chatInfo)
                
                chatViewModel.saveChatInfo(chatInfo: response)
                
                DispatchQueue.main.async {
                    self.presentChatViewController(chatInfo: response)
                }
            }
        }
    }
    
    private func presentChatViewController(chatInfo: ChatInfo){
        let vc = ChatViewController()
        vc.chatInfo = chatInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: CollectionView 관련
extension CreateGroupChatViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatViewModel.chatOptionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = chatOptionCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        
        cell.configureView(chatViewModel.chatOptionArray[indexPath.item])
        
        return cell
    }
}

extension CreateGroupChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, data: chatViewModel.chatOptionArray[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension CreateGroupChatViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chatViewModel.chatOptionArray[indexPath.item].toggle()
        chatOptionCollectionView.reloadData()
    }
}

//MARK: ImageEdit 관련
extension CreateGroupChatViewController: ProfileImageViewDelegate{
    func editButtonTapped() {
        let alert = self.chatImageView.alert { self.present(self.imagePicker, animated: true) }
        self.present(alert, animated: true)
    }
}

extension CreateGroupChatViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageEditViewController.pickedImage = pickedImage
            imagePicker.pushViewController(imageEditViewController, animated: false)
        }
    }
}

extension CreateGroupChatViewController: ImageEditViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true)
        guard let image = image else { return }
        chatImageView.setImage(image)
    }
}

