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
        
        chatNameLabel.setLabel(textColor: .black, fontSize: 15)
        peopleNumberLabel.setLabel(textColor: .darkGray, fontSize: 13)
        
        latestChatTimeLabel.setLabel(textColor: .gray, fontSize: 11)
        
        latestMessageLabel.setLabel(textColor: .gray, fontSize: 12)
        latestMessageLabel.numberOfLines = 2
    }
    
    func initView(groupChatData: GroupChatData){
        chatImageView.image = UIImage(named: groupChatData.chatImage)
        chatNameLabel.text = groupChatData.chatName
        peopleNumberLabel.text = String(groupChatData.peopleNumber)
        latestMessageLabel.text = groupChatData.latestMessage
        latestChatTimeLabel.text = groupChatData.latestChatTime
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
