//
//  PlayListTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import UIKit
import Kingfisher

class PlayListTableViewCell: UITableViewCell {
    
    static let identifier = "PlayListTableViewCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var uploaderLabel: SDGothicLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureView(){
        titleLabel.setLabel(textColor: .black, fontSize: 15)
        titleLabel.numberOfLines = 2
        
        uploaderLabel.setLabel(textColor: .black, fontSize: 13)
    }
    
    func setVideo(_ video: Video){
        if let url = URL(string: video.thumbnail){
            thumbnailImageView.kf.setImage(with: url)
        }
        titleLabel.text = video.title
        uploaderLabel.text = video.uploader
    }
}
