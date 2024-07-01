//
//  ChatTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/28/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    static let identifier = "ChatTableViewCell"

    @IBOutlet weak var messageLabel: MessageLabel!
    
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
        messageLabel.isMyChat = true
        messageLabelWidthContraint.constant = self.bounds.width * 0.7
    }
    
    func setText(text: String){
        messageLabel.setText(text: text)
        
        let estimatedWidth = messageLabel.width(text: text)
        if estimatedWidth < messageLabelWidthContraint.constant{
            messageLabelWidthContraint.constant = estimatedWidth
        } else {
            messageLabelWidthContraint.constant = self.bounds.width * 0.7
        }
    }
    
    func estimatedHeight(text: String)-> CGFloat{
        let spacing: CGFloat = 3
        return messageLabel.height(text: text) + (spacing * 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
