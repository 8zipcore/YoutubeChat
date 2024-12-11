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
    private var loadTime: Double = 0
    var shouldSeek = false
    
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
        self.backgroundColor = .clear
        
        youtubeView = YTPlayerView()
        youtubeView?.delegate = self
        
        self.addSubview(youtubeView!)
        
        youtubeView?.backgroundColor = .clear
        
        youtubeView!.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    func playVideo(_ video: Video){
        self.video = video
        self.loadTime = Date().timeIntervalSince1970
        self.youtubeView?.load(withVideoId: video.youtubeId, playerVars: ["autoplay": 1])
    }
    
    func stopVideo(){
        self.youtubeView?.stopVideo()
    }
}

extension YoutubeView: YTPlayerViewDelegate{
    // 플레이어가 준비되었을 때 호출되는 메소드
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("Player is ready.")
        if shouldSeek{
            guard let video = video else { print("🌀 video Data Nil Error"); return }
            let delaySecond = Float(Date().timeIntervalSince1970 - loadTime)
            var startSecond: Float = 0
            if video.startTime > 0 {
                startSecond = Float(round(Date().timeIntervalSince1970 - video.startTime))
            }
            playerView.seek(toSeconds: startSecond + delaySecond, allowSeekAhead: true)
            shouldSeek = false
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        guard let video = video else { print("🌀 video Data Nil Error"); return }
        if state == .playing{
            delegate?.didStartVideo(video)
        } else if state == .ended{
            delegate?.didEndVideo(video)
        }
    }
}
