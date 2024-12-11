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
    @IBOutlet var chatOptionLabel: [SDGothicLabel]!
    @IBOutlet var chatOptionSwitch: [UISwitch]!
    @IBOutlet weak var passwordTextField: InputTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmButton: ConfirmButton!
    
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextFieldHeightConstraint: NSLayoutConstraint!
    
    private let cellHeight: CGFloat = 30
    private let cellSpacing: CGFloat = 10
    
    private var imagePicker = UIImagePickerController()
    private var confirmImageViewController = ConfirmImageViewController()
    
    var chatViewModel = ChatViewModel()
    var viewType: ViewType?
    var chatRoom: ChatRoomData?
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    var activeTextField: InputTextField?
    var activeTextView: InputTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextViewHeightConstraint.constant = descriptionTextView.estimatedHeight()
    }
    
    private func configureView(){
        self.view.backgroundColor = .black
        
        titleLabel.setLabel(textColor: .white, fontSize: 19)
        
        chatNameTextField.setText(title: "채팅방 이름", placeHolder: "채팅방 이름을 입력해주세요.", maxLength: 30)
        chatNameTextField.delegate = self
        
        descriptionTextView.setText(title: "채팅방 소개", placeHolder: "해시태그로 채팅방을 소개해보세요.", maxLength: 80)
        descriptionTextView.delegate = self
        
        passwordTextField.setPlaceHolder("비밀번호를 입력하세요. 영문/숫자 4 ~ 8 자리")
        passwordTextFieldHeightConstraint.constant = 0
        passwordTextField.isHidden = true
        passwordTextField.delegate = self

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        confirmImageViewController.modalPresentationStyle = .fullScreen
        confirmImageViewController.delegate = self
        
        chatRoomImageView.delegate = self
        
        chatOptionLabel.forEach{
            $0.setLabel(textColor: Colors.lightGray, fontStyle: .semibold, fontSize: 15)
        }
        
        chatOptionSwitch.forEach{
            $0.backgroundColor = UIColor(white: 1, alpha: 0.3)
            $0.layer.cornerRadius = $0.bounds.size.height / 2
            $0.onTintColor = Colors.blue
            $0.isOn = $0.tag != 2
            $0.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }

        switch viewType {
        case .create:
            titleLabel.text = "채팅방 만들기"
        case .edit:
            guard let chatRoom = chatRoom else { return }
            titleLabel.text = "채팅방 편집"
            chatNameTextField.setText(chatRoom.name)
            descriptionTextView.setText(text: chatRoom.description)
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
        } else if isOn(.password) && !isPasswordValid(){
            passwordTextField.setText("")
            passwordTextField.showAnimation()
        } else {
            if viewType == .create{
                confirmButton.showLoading()
            }
            Task{
                switch viewType {
                case .create:
                    let chatOptions = chatOptionSwitch.filter({$0.isOn}).map{ return $0.tag }
                    print("chatOptions", chatOptions)
                    let chatRoom = ChatRoom(name: chatNameTextField.text, description: descriptionTextView.text, image: chatRoomImageView.imageToString(), enterCode: self.passwordTextField.text, hostId: MyProfile.id, participantIds: [MyProfile.id], allParticipantIds: [MyProfile.id], chatOptions: chatOptions, categories: descriptionTextView.hashTagTextArray(), lastChatTime: -1)
                    let response = try await chatViewModel.createChatRoom(chatRoom: chatRoom)
                    DispatchQueue.main.async {
                        self.presentChatViewController(chatRoom: response)
                    }
                    confirmButton.hideLoading()
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
    
    private func isOn(_ chatOption: ChatOption) -> Bool {
        return chatOptionSwitch[chatOption.rawValue].isOn
    }
    
    private func isPasswordValid() -> Bool{
        let password = passwordTextField.text
        
        if !(password.count > 3 && password.count < 9) {
            return false
        }
        
        let regex = "^[A-Za-z0-9]+$"
        
        if let _ = password.range(of: regex, options: .regularExpression){
            return true
        }
        
        return false
    }
}

extension CreateChatRoomViewController{
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.tag == 2 {
            let isOn = sender.isOn
            let height = isOn ? chatNameTextField.bounds.height : 0

            passwordTextFieldHeightConstraint.constant = height
            passwordTextField.isHidden = !isOn
            self.view.layoutIfNeeded()
            //scrollView.contentSize.height += height

            if isOn {
                passwordTextField.showKeyboard()
            } else {
                passwordTextField.hideKeyboard()
            }

        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardYPoint = keyboardFrame.minY
        var maxY: CGFloat = 0
        
        if let activeTextField = activeTextField {
            maxY = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
        } else if let activeTextView = activeTextView {
            maxY = activeTextView.convert(activeTextView.bounds, to: self.view).maxY
        }
        
        let spacing: CGFloat = 20

        if keyboardYPoint - maxY < spacing{
            let bottomInset = spacing - (keyboardYPoint - maxY)
            scrollView.setContentOffset(CGPoint(x: 0, y: bottomInset), animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.activeTextField = nil
        self.activeTextView = nil
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
//MARK: InputTextFieldDelegate / InputTextViewDelegate
extension CreateChatRoomViewController: InputTextFieldDelegate, InputTextViewDelegate{
    func textFieldDidBeginEditing(_ sender: InputTextField) {
        self.activeTextField = sender
    }
    
    func textViewDidBeginEditing(_ sender: InputTextView) {
        self.activeTextView = sender
    }
}
