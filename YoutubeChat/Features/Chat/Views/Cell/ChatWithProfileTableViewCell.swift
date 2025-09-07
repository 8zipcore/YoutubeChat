//
//  ChatWithProfileTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit

class ChatWithProfileTableViewCell: UITableViewCell {
  
  static let identifier = "ChatWithProfileTableViewCell"
  
  private var nameLabelTopSpacing: CGFloat = 6
  private var nameLabelHeight: CGFloat = 18
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: SDGothicLabel!
  @IBOutlet weak var messageLabel: MessageLabel!
  
  @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var messageLabelWidthContraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureView()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    let estimatedWidth = messageLabel.width(text: self.messageLabel.text)
    if estimatedWidth < messageLabelWidthContraint.constant{
      messageLabelWidthContraint.constant = estimatedWidth
    } else {
      messageLabelWidthContraint.constant = self.bounds.width * 0.7
    }
  }
  
  private func configureView(){
    self.backgroundColor = .clear
    
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
    
    nameLabel.setLabel(textColor: .white, fontSize: 13)
    nameLabelHeightConstraint.constant = nameLabelHeight
  }
  
  func setText(text: String, user: User?, profileHidden: Bool){
    messageLabel.setText(text: text)
    
    nameLabel.text = user?.name
    profileImageView.setImageWithDefault(imageURLString: user?.image ?? "")
    
    let estimatedWidth = messageLabel.width(text: text)
    if estimatedWidth < messageLabelWidthContraint.constant{
      messageLabelWidthContraint.constant = estimatedWidth
    } else {
      messageLabelWidthContraint.constant = self.bounds.width * 0.7
    }
    
    self.profileImageView.isHidden = profileHidden
    self.nameLabel.isHidden = profileHidden
    if profileHidden {
      self.nameLabelHeightConstraint.constant = 0
      self.nameLabelTopConstraint.constant = 0
    } else {
      self.nameLabelHeightConstraint.constant = nameLabelHeight
      self.nameLabelTopConstraint.constant = nameLabelTopSpacing
    }
  }
  
  func estimatedHeight(text: String, profileHidden: Bool)-> CGFloat{
    let spacing: CGFloat = 6
    let messageLabelHeight = messageLabel.height(text: text)
    if profileHidden{
      return spacing + messageLabelHeight
    } else {
      return nameLabelTopSpacing + nameLabelHeight + spacing + messageLabelHeight
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
