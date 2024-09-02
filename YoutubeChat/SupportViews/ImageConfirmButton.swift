//
//  ImageConfirmButton.swift
//  YoutubeChat
//
//  Created by 홍승아 on 9/1/24.
//

import UIKit
import SnapKit

class ImageConfirmButton: UIView {
    
    let imageView = UIImageView()
    let label = SDGothicLabel()
    var touchView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView(){
        self.backgroundColor = Colors.blue
        self.layer.cornerRadius = 10
        
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(touchView)
        
        label.snp.makeConstraints{ make in
            make.centerX.equalToSuperview().multipliedBy(1.05)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints{ make in
            make.centerY.equalTo(label.snp.centerY).multipliedBy(0.95)
            make.trailing.equalTo(label.snp.leading).inset(-7)
            make.width.equalTo(self.bounds.width * 0.045)
            make.height.equalTo(self.bounds.width * 0.045)
        }
        
        touchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.setLabel(textColor: .white, fontStyle: .semibold, fontSize: 18)
        label.textAlignment = .center
        
        touchView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        touchView.isUserInteractionEnabled = false
        touchView.alpha = 0
        touchView.layer.cornerRadius = 10
        

    }
    
    func setButton(_ image: UIImage?, _ title: String){
        self.label.text = title
        
        var multiple: CGFloat = 1
        if let image = image {
            multiple = 0.95
            self.imageView.image = image
        }
        
        imageView.snp.makeConstraints{ make in
            make.centerY.equalTo(label.snp.centerY).multipliedBy(multiple)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.touchView.alpha = 0.8
            }, completion: nil)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchView.alpha = 0.8
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.touchView.alpha = 0
            }, completion: nil)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchView.alpha = 0.8
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.touchView.alpha = 0
            }, completion: nil)
        }
    }
}
