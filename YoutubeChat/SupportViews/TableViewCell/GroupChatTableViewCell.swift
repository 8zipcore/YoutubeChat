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
    @IBOutlet weak var lastChatTimeLabel: SDGothicLabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    @IBOutlet weak var lockImageViewWidthConstraint: NSLayoutConstraint!
    
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
        
        lastChatTimeLabel.setLabel(textColor: Colors.lightGray, fontSize: 12)
        
        self.selectionStyle = .none
    }
    
    func initView(chatRoom: ChatRoomData){
        chatImageView.setImageWithDefault(imageString: chatRoom.image)
        chatNameLabel.text = chatRoom.name
        peopleNumberLabel.text = String(chatRoom.participantIds.count)
        descriptionLabel.text = chatRoom.description
        lastChatTimeLabel.text =  lastChatTimeToText(chatRoom.lastChatTime)
        
        lockImageViewWidthConstraint.constant = chatRoom.isOptionContains(.password) ? self.bounds.width * 0.03 : 0
    }

    func showSeletedAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .red
        })
    }
    
    func lastChatTimeToText(_ lastChatTime:Double) -> String{
        if lastChatTime < 0 {
            return ""
        }
        
        let time = Date().timeIntervalSince1970 - lastChatTime
        let minuteToSecond: Double = 60
        let hourToSecond: Double = 60 * minuteToSecond
        let dayToSecond: Double = 24 * hourToSecond
        let weekToSecond: Double = 7 * dayToSecond
        
        if time < 3 * minuteToSecond{
            return "방금"
        } else if time < hourToSecond {
            return "\(Int(floor(time / minuteToSecond)))분"
        } else if time < dayToSecond {
            return "\(Int(floor(time / hourToSecond)))시간"
        } else if time < weekToSecond {
            return "\(Int(floor(time / dayToSecond)))일"
        } else {
            return "\(Int(floor(time / weekToSecond)))주"
        }
        
    }
    
}
