//
//  ChatWithProfileTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit

class ChatWithProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ChatWithProfileTableViewCell"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: SDGothicLabel!
    @IBOutlet weak var messageLabel: MessageLabel!
    
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
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
        
        nameLabel.setLabel(textColor: .black, fontSize: 13)
        nameLabelHeightConstraint.constant = self.bounds.height * 0.1
    }
    
    func setText(text: String, user: User?, profileHidden: Bool){
        messageLabel.setText(text: text)
        
        nameLabel.text = user?.name
        profileImageView.setImage(imageString: user?.image ?? "")
        
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
        }
    }
    
    func estimatedHeight(text: String, profileHidden: Bool)-> CGFloat{
        let spacing: CGFloat = 6
        if profileHidden{
            return spacing + messageLabel.height(text: text)
        } else {
            return (self.bounds.height * 0.1) + spacing + messageLabel.height(text: text)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
