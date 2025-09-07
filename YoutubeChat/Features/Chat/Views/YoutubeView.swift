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
    self.youtubeView?.load(withVideoId: video.youtubeId, playerVars: ["autoplay": 1])
  }
  
  func stopVideo(){
    self.youtubeView?.stopVideo()
  }
  
  func seekVideo(){
    guard let video = video else { print("🌀 video Data Nil Error"); return }
    var startSecond: Float = 0
    if video.startTime > 0 {
      startSecond = Float(round(Date().timeIntervalSince1970 - video.startTime))
    }
    youtubeView?.seek(toSeconds: startSecond, allowSeekAhead: true)
    shouldSeek = false
  }
}

extension YoutubeView: YTPlayerViewDelegate{
  func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    print("Player is ready.")
    if shouldSeek{
      seekVideo()
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
