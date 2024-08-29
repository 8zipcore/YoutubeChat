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
    @IBOutlet weak var descriptionLabel: SDGothicLabel!
    @IBOutlet weak var peopleNumberLabel: SDGothicLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurView()
    }
    
    private func configurView(){
        self.backgroundColor = .clear
        
        chatImageView.contentMode = .scaleAspectFill
        chatImageView.clipsToBounds = true
        chatImageView.layer.cornerRadius = (self.bounds.height * 0.77) / 2.5
        
        chatNameLabel.setLabel(textColor: .white, fontStyle: .bold, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: .lightGray, fontStyle: .semibold, fontSize: 13)
        
        descriptionLabel.setLabel(textColor: .init(white: 1, alpha: 0.8), fontStyle: .semibold, fontSize: 12)
        descriptionLabel.numberOfLines = 2
        
        self.selectionStyle = .none
    }
    
    func initView(chatRoom: ChatRoomData){
        chatImageView.setImage(imageString: chatRoom.image)
        chatNameLabel.text = chatRoom.name
        peopleNumberLabel.text = String(chatRoom.participantIds.count)
        descriptionLabel.text = chatRoom.description
        // latestChatTimeLabel.text = myChatInfo.timestamp
    }

    func showSeletedAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .red
        })
    }
}
