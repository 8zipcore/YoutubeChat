//
//  YoutubeView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/2/24.
//

import UIKit
import SnapKit
import WebKit

class YoutubeView: UIView {
     
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
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        
        self.addSubview(webView)
        
        webView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        guard let url = URL(string: "https://www.youtube.com/embed/Js67kofnQw0") else { return  }
        webView.load(URLRequest(url: url))
    }
}
