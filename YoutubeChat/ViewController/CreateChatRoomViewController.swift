//
//  CreateChatRoomViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/17/24.
//

import UIKit

class CreateChatRoomViewController: BaseViewController, UIImagePickerControllerDelegate{
    
    enum ViewType{
        case create, edit
    }

    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var chatRoomImageView: ChatRoomImageView!
    @IBOutlet weak var chatNameTextField: InputTextField!
    @IBOutlet weak var descriptionTextView: InputTextView!
    @IBOutlet weak var chatOptionLabel: SDGothicLabel!
    @IBOutlet weak var chatOptionCollectionView: UICollectionView!
    
    @IBOutlet weak var chatOptionCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!

    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 10
    
    private var imagePicker = UIImagePickerController()
    private var confirmImageViewController = ConfirmImageViewController()
    
    var chatViewModel = ChatViewModel()
    var viewType: ViewType?
    var chatRoom: ChatRoomData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextViewHeightConstraint.constant = descriptionTextView.estimatedHeight()
        chatOptionCollectionViewHeight.constant = chatOptionCollectionView.contentSize.height
    }
    
    private func configureView(){
        self.view.backgroundColor = .black
        
        titleLabel.setLabel(textColor: .white, fontSize: 17)
        
        chatNameTextField.setText(title: "채팅방 이름", placeHolder: "채팅방 이름을 입력해주세요.", maxLength: 30)
        descriptionTextView.setText(title: "채팅방 소개", placeHolder: "해시태그로 채팅방을 소개해보세요.", maxLength: 80)
        chatOptionLabel.setLabel(textColor: .white, fontSize: 13)
        
        chatOptionCollectionView.dataSource = self
        chatOptionCollectionView.delegate = self       
        chatOptionCollectionView.register(ChatOptionCollectionViewCell.self, forCellWithReuseIdentifier: ChatOptionCollectionViewCell.identifier)
        
        let layout = LeftAlignedFlowLayout()
        layout.minimumInteritemSpacing = cellSpacing // 셀 사이의 간격
        layout.minimumLineSpacing = 10      // 줄 사이의 간격
        layout.sectionInset = .zero

        chatOptionCollectionView.collectionViewLayout = layout
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        confirmImageViewController.modalPresentationStyle = .fullScreen
        confirmImageViewController.delegate = self
        
        chatRoomImageView.delegate = self
        
        switch viewType {
        case .create:
            titleLabel.text = "채팅방 만들기"
        case .edit:
            guard let chatRoom = chatRoom else { return }
            titleLabel.text = "채팅방 편집"
            chatNameTextField.setText(chatRoom.name)
            descriptionTextView.setText(text: chatRoom.description)
            for index in chatViewModel.chatOptionArray.indices{
                if chatRoom.chatOptions.contains(chatViewModel.chatOptionArray[index].chatOption.rawValue){
                    chatViewModel.chatOptionArray[index].isSelected = true
                }
            }
        case nil:
            break
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if self.navigationController == nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if chatNameTextField.isBlank(){
            chatNameTextField.showAnimation()
        } else {
            Task{
                switch viewType {
                case .create:
                    let chatRoom = ChatRoom(name: chatNameTextField.text, description: descriptionTextView.text, image: chatRoomImageView.imageToString(), enterCode: "", hostId: MyProfile.id, participantIds: [MyProfile.id], chatOptions: chatViewModel.selectedChatOptions(), categories: descriptionTextView.hashTagTextArray(), lastChatTime: -1)
                    
                    let response = try await chatViewModel.createChatRoom(chatRoom: chatRoom)
                    DispatchQueue.main.async {
                        self.presentChatViewController(chatRoom: response)
                    }
                case .edit:
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                case nil:
                    break
                }
            }
        }
    }
    
    private func presentChatViewController(chatRoom: ChatRoomData){
        let vc = ChatViewController()
        vc.chatRoom = chatRoom
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: CollectionView 관련
extension CreateChatRoomViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatViewModel.chatOptionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = chatOptionCollectionView.dequeueReusableCell(withReuseIdentifier: ChatOptionCollectionViewCell.identifier, for: indexPath) as? ChatOptionCollectionViewCell else {
             return UICollectionViewCell()
        }
        let option = chatViewModel.chatOptionArray[indexPath.item]
        cell.configureView(image: nil, title: option.title, isSelected: option.isSelected)
        return cell
    }
}

extension CreateChatRoomViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let option = chatViewModel.chatOptionArray[indexPath.item]
        return ChatOptionCollectionViewCell.fittingSize(cellHeight: cellHeight, image: nil, title: option.title, isSelected: option.isSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension CreateChatRoomViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chatViewModel.chatOptionArray[indexPath.item].toggle()
        chatOptionCollectionView.reloadData()
    }
}

//MARK: ImageEdit 관련
extension CreateChatRoomViewController: ChatRoomImageViewDelegate{
    func editButtonTapped() {
        let alert = self.chatRoomImageView.alert { self.present(self.imagePicker, animated: true) }
        self.present(alert, animated: true)
    }
}

extension CreateChatRoomViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            confirmImageViewController.pickedImage = pickedImage
            imagePicker.pushViewController(confirmImageViewController, animated: false)
        }
    }
}

extension CreateChatRoomViewController: EditImageViewControllerDelegate{
    func didDismissWithImage(image: UIImage?) {
        self.dismiss(animated: true)
        guard let image = image else { return }
        chatRoomImageView.setImage(image)
    }
}

