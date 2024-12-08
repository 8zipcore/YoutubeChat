//
//  ChatRoomInfoViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/7/24.
//

import UIKit

class ChatRoomInfoViewController: BaseViewController {

    @IBOutlet weak var nameLabel: SDGothicLabel!
    @IBOutlet weak var descriptionLabel: SDGothicLabel!
    @IBOutlet weak var optionLabel: SDGothicLabel!
    @IBOutlet weak var chatRoomImageView: UIImageView!
    @IBOutlet weak var enterButton: ImageConfirmButton!
    
    private var chatViewModel = ChatViewModel()
    
    var chatRoom: ChatRoomData?
    var id: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        guard let chatRoom = chatRoom else {
            print("🌀 ChatRoom Data Nil Error")
            fetchChatRoom()
            return
        }
        nameLabel.setLabel(textColor: .white, fontStyle: .bold, fontSize: 25)
        descriptionLabel.setLabel(textColor: Colors.gray, fontSize: 18)
        optionLabel.setLabel(textColor: Colors.lightGray, fontSize: 15)
        
        let buttonImage = chatRoom.isOptionContains(.password) ? UIImage(named: "lock_icon") : nil
        enterButton.setButton(buttonImage, "참여하기")
        
        optionLabel.textAlignment = .right
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byCharWrapping
        
        nameLabel.text = chatRoom.name
        descriptionLabel.text = chatRoom.description
        optionLabel.text = chatViewModel.optionText(chatRoom)
        chatRoomImageView.setImage(imageString: chatRoom.image)
        
        self.enterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterButtonTapped(_:))))
    }
    
    private func fetchChatRoom(){
        guard let id = id else { print("🌀 ID Nil Error") ; return }
        Task{
            self.chatRoom = try await chatViewModel.findChatRoom(id:id)
            
            DispatchQueue.main.async {
                self.configureView()
            }
        }
    }

    @objc func enterButtonTapped(_ sender: Any) {
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
        
        if chatRoom.isOptionContains(.password){
            showPasswordAlert()
        } else {
            enterButton.showLoading()
            enterChatRoom(chatRoom: chatRoom, enterCode: "")
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func enterChatRoom(chatRoom: ChatRoomData, enterCode: String){
        Task{
            let chatRoomResponseData = try await chatViewModel.enterChatRoom(id: chatRoom.id!, enterCode: enterCode)
            DispatchQueue.main.async{
                self.enterButton.hideLoading()
            }
            switch chatRoomResponseData.responseCode {
            case .success:
                let vc = ChatViewController()
                vc.chatRoom = chatRoomResponseData.chatRoom!
                vc.isEnter = true
                DispatchQueue.main.async{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure:
                // 존재하지 않는 방입니다?
                // alert 추가
                showFailureAlert()
            case .invalid:
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showPasswordAlert(){
        let alert = UIAlertController(title: nil, message: "비밀번호 입력", preferredStyle: .alert)
        
        // 첫 번째 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "영문/숫자 4~8자리"
            textField.keyboardType = .default
        }
        
        // 확인 버튼 추가
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let textFields = alert.textFields {
                if let chatRoom = self.chatRoom, let firstText = textFields.first?.text{
                    self.enterChatRoom(chatRoom: chatRoom, enterCode: firstText)
                }
            }
        }
        alert.addAction(okAction)
        
        // 취소 버튼 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        
        // 알림을 표시
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showFailureAlert(){
        let alert = UIAlertController(title: nil, message: "코드를 잘못 입력했습니다.\n영문/숫자 4~8자리로 입력해주세요.", preferredStyle: .alert)
        
        // 확인 버튼 추가
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        // 알림을 표시
        self.present(alert, animated: true, completion: nil)
    }
}
