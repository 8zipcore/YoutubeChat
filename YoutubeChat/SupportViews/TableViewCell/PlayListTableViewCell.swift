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

    private func configureView(){
        self.backgroundColor = .clear
        
        titleLabel.setLabel(textColor: .white, fontSize: 15)
        titleLabel.numberOfLines = 2
        
        uploaderLabel.setLabel(textColor: .white, fontSize: 13)
        
        thumbnailImageView.layer.cornerRadius = 10
    }
    
    func setVideo(_ video: Video){
        if let url = URL(string: video.thumbnail){
            thumbnailImageView.kf.setImage(with: url)
        }
        titleLabel.text = video.title
        uploaderLabel.text = video.uploader
    }
}
