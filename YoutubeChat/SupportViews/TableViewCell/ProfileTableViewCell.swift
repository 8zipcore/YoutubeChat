//
//  ProfileTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/24/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var nameLabel: SDGothicLabel!
    
    @IBOutlet weak var leaderImageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureView(_ user: User, _ isHost: Bool){
        profileImageView.setImage(user.image)
        nameLabel.text = user.name
        leaderImageWidthConstraint.constant = isHost ? 12 : 0
    }
    
}
