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
  @IBOutlet weak var leaderImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.backgroundColor = .clear
    nameLabel.setLabel(textColor: .white, fontSize: 15)
  }
  
  func configureView(_ user: User, _ isHost: Bool){
    profileImageView.setImage(user.image)
    nameLabel.text = user.name
    leaderImageView.isHidden = !isHost
  }
}
