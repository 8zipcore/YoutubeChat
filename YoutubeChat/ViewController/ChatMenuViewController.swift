//
//  ChatMenuViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/24/24.
//

import UIKit

class ChatMenuViewController: BaseViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var chatRoomEditButton: UIButton!
    @IBOutlet weak var enterCodeShareButton: UIButton!
    @IBOutlet weak var participantsLabel: SDGothicLabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var chatRoom: ChatRoomData?
    
    @IBOutlet weak var chatRoomEditButtonTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView(){
        participantsLabel.setLabel(textColor: .white, fontStyle: .semibold, fontSize: 15)
        
        profileTableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        profileTableView.dataSource = self
        profileTableView.delegate = self 
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        if let editImage = UIImage(named: "edit_icon")?.withRenderingMode(.alwaysTemplate){
            self.chatRoomEditButton.setImage(editImage, for: .normal)
            self.chatRoomEditButton.tintColor = UIColor(white: 1, alpha: 0.5)
        }
        
        if let shareImage = UIImage(named: "share_icon")?.withRenderingMode(.alwaysTemplate){
            self.enterCodeShareButton.setImage(shareImage, for: .normal)
            self.enterCodeShareButton.tintColor = UIColor(white: 1, alpha: 0.5)
        }
        
        /*
        if let chatRoom = chatRoom {
            if chatRoom.hostId != MyProfile.id{
                chatRoomEditButtonTrailingConstraint.constant = -chatRoomEditButton.bounds.width
            }
        }*/
    }
    
    @objc func dismiss(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func chatRoomEditButtonTapped(_ sender: Any) {
        let vc = CreateChatRoomViewController()
        vc.viewType = .edit
        vc.chatRoom = chatRoom
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func enterCodeShareButtonTapped(_ sender: Any) {

    }
}

extension ChatMenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom?.participants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = profileTableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        if let chatRoom = chatRoom {
            let user = chatRoom.participants[indexPath.item]
            cell.configureView(user, user.id == chatRoom.hostId)
        }
        
        return cell
    }
}

extension ChatMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contentView.bounds.width * 140 / 546
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chatRoom = chatRoom {
            let vc = ProfileInfoViewController()
            vc.user = chatRoom.participants[indexPath.item]
            vc.viewType = .userProfile
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
