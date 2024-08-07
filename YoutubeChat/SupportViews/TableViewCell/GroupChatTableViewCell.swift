//
//  GroupChatTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/13/24.
//

import UIKit

class GroupChatTableViewCell: UITableViewCell {
    
    static let identifier = "GroupChatTableViewCell"
    
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: SDGothicLabel!
    @IBOutlet weak var latestMessageLabel: SDGothicLabel!
    @IBOutlet weak var peopleNumberLabel: SDGothicLabel!
    @IBOutlet weak var latestChatTimeLabel: SDGothicLabel!
    @IBOutlet weak var newMessageIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurView()
    }
    
    private func configurView(){
        chatImageView.contentMode = .scaleAspectFill
        chatImageView.clipsToBounds = true
        chatImageView.layer.cornerRadius = (self.bounds.height * 0.77) / 2.5
        chatImageView.backgroundColor = Colors.pastelBlue
        
        chatNameLabel.setLabel(textColor: .black, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: .darkGray, fontSize: 13)
        
        latestChatTimeLabel.setLabel(textColor: .gray, fontSize: 11)
        
        latestMessageLabel.setLabel(textColor: .gray, fontSize: 12)
        latestMessageLabel.numberOfLines = 2
        
        self.selectionStyle = .none
    }
    
    func initView(chatRoom: ChatRoom){
        chatImageView.setImage(imageString: chatRoom.image)
        chatNameLabel.text = chatRoom.name
        peopleNumberLabel.text = String(chatRoom.participantIds.count)
        // latestMessageLabel.text = myChatInfo.lastMessage
        // latestChatTimeLabel.text = myChatInfo.timestamp
    }

    func showSeletedAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .red
        })
    }
}
