//
//  YoutubeView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/2/24.
//

import UIKit
import SnapKit
import WebKit
import YouTubeiOSPlayerHelper

protocol YoutubeViewDelegate{
    func didStartVideo(_ video: Video)
    func didEndVideo(_ video: Video)
}

class YoutubeView: UIView {
    
    var youtubeView: YTPlayerView?
    
    private var video: Video?
    
    var delegate: YoutubeViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configreView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configreView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configreView(){
        youtubeView = YTPlayerView()
        youtubeView?.delegate = self
        
        self.addSubview(youtubeView!)
        
        youtubeView!.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    func playYoutube(_ video: Video){
        self.video = video
        // let startTime = Date().timeIntervalSince1970 - video.startTime
        self.youtubeView?.load(withVideoId: video.id, playerVars: ["start" : 0, "autoplay": 1])
    }
}

extension YoutubeView: YTPlayerViewDelegate{
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        guard let video = video else { print("🌀 video Data Nil Error"); return }
        if state == .playing{
            delegate?.didStartVideo(video)
        } else if state == .ended{
            delegate?.didEndVideo(video)
        }
    }
}
