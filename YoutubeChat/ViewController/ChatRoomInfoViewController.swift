//
//  ChatRoomInfoViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/7/24.
//

import UIKit

class ChatRoomInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: SDGothicLabel!
    @IBOutlet weak var descriptionLabel: SDGothicLabel!
    @IBOutlet weak var optionLabel: SDGothicLabel!
    @IBOutlet weak var chatRoomImageView: UIImageView!
    @IBOutlet weak var enterButton: ConfirmButton!
    
    private var chatViewModel = ChatViewModel()
    
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        guard let chatRoom = chatRoom else { print("🌀 ChatRoom Data Error !"); return }
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
            let chatRoom = try await chatViewModel.enterChatRoom(id: chatRoom!.id!)
            let vc = ChatViewController()
            vc.chatRoom = chatRoom
            DispatchQueue.main.async{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
