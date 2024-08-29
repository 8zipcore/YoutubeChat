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
    @IBOutlet weak var enterButton: ConfirmButton!
    
    private var chatViewModel = ChatViewModel()
    
    var chatRoom: ChatRoomData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Nil Error") ; return }
        nameLabel.setLabel(textColor: .white, fontStyle: .bold, fontSize: 25)
        descriptionLabel.setLabel(textColor: Colors.gray, fontSize: 18)
        optionLabel.setLabel(textColor: Colors.lightGray, fontSize: 15)
        
        enterButton.setTitle("참여하기")
        
        optionLabel.textAlignment = .right
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byCharWrapping
        
        nameLabel.text = chatRoom.name
        descriptionLabel.text = chatRoom.description
        optionLabel.text = chatViewModel.optionText(chatRoom)
        chatRoomImageView.setImage(imageString: chatRoom.image)
    }

    @IBAction func enterButtonTapped(_ sender: Any) {
        Task{
            let chatRoomResponseData = try await chatViewModel.enterChatRoom(id: chatRoom!.id!)
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
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
