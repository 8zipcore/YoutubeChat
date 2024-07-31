//
//  ChatTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/26/24.
//

import UIKit
import SnapKit

protocol ChatTextViewDelegate{
    func setChatTextViewHeight(_ height: CGFloat)
    func sendButtonTapped(_ sender: UIButton)
    func galleryButtonTapped(_ sender: UIButton)
    func youtubeButtonTapped(_ sender: UIButton)
}

class ChatTextView: UIView {
 
    enum ButtonType: Int{
        case send = 0, gallery, youtube
    }
    
    let textView = UITextView()
    var buttonArray: [UIButton] = [UIButton(), UIButton(), UIButton()]
    var delegate: ChatTextViewDelegate?
    private var lineCount: CGFloat = 0
    private var maxLineCount: CGFloat = 5
    
    var textViewTrailingConstraint: Constraint?
    
    var text: String{
        return self.textView.text
    }

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
        for index in buttonArray.indices{
            buttonArray[index].tag = index
            self.addSubview(buttonArray[index])
        }
        
        self.addSubview(textView)
        
        textView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        buttonArray.forEach{ button in
            switch ButtonType(rawValue: button.tag){
            case .send:
                button.snp.makeConstraints{ make in
                    make.trailing.equalToSuperview().inset(10)
                    make.bottom.equalToSuperview()
                }
                break
            case .gallery:
                button.snp.makeConstraints{ make in
                    make.trailing.equalToSuperview().inset(10)
                    make.bottom.equalToSuperview()
                }
                break
            case .youtube:
                button.snp.makeConstraints{ make in
                    make.trailing.equalTo(self.button(.gallery).snp.leading).inset(-5)
                    make.bottom.equalToSuperview()
                }
                break
            case .none:
                break
            }
        }
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.bounds.height / 2.5
        self.clipsToBounds = true
        
        textView.font = SDGothic(size: 15)
        textView.textColor = .black
        textView.tintColor = Colors.gray
        
        textView.delegate = self
        
        configureButton()
        
        self.layoutIfNeeded()
        setTextView()
    }
    
    func estimatedHeight()-> CGFloat{
        let size = CGSize(width: self.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        return estimatedSize.height
    }
    
    func resetText(){
        self.textView.text = ""
        setTextView()
    }
}
// MARK: Button 관련
extension ChatTextView{
    func configureButton(){
        buttonArray.forEach{ button in
            switch ButtonType(rawValue: button.tag){
            case .send:
                button.setTitle("전송", for: .normal)
                button.setTitleColor(.black, for: .normal)
                break
            case .gallery:
                button.setTitle("이미지", for: .normal)
                button.setTitleColor(.black, for: .normal)
                break
            case .youtube:
                button.setTitle("유튜브", for: .normal)
                button.setTitleColor(.black, for: .normal)
                break
            case .none:
                break
            }
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
        }
    }
    
    func button(_ type: ButtonType) -> UIButton{
        switch type{
        case .send:
            return self.buttonArray[ButtonType.send.rawValue]
        case .gallery:
            return self.buttonArray[ButtonType.gallery.rawValue]
        case .youtube:
            return self.buttonArray[ButtonType.youtube.rawValue]
        }
    }
    
    func setTextView(){
        textViewTrailingConstraint?.deactivate()
        
        if textView.text.count > 0 && self.button(.send).isHidden{
            self.button(.send).isHidden = false
            self.button(.youtube).isHidden = true
            self.button(.gallery).isHidden = true
            
            let trailingSpacing: CGFloat = 10
            let trailingMargin = self.button(.send).bounds.width + trailingSpacing
            textView.snp.makeConstraints{
                textViewTrailingConstraint = $0.trailing.equalToSuperview().inset(trailingMargin).constraint
            }
        }
        
        if textView.text.count == 0{
            self.button(.send).isHidden = true
            self.button(.youtube).isHidden = false
            self.button(.gallery).isHidden = false
            
            let trailingSpacing: CGFloat = 10
            let trailingMargin = self.button(.youtube).bounds.width + self.button(.gallery).bounds.width + (trailingSpacing * 2)
            textView.snp.makeConstraints{
                self.textViewTrailingConstraint = $0.trailing.equalToSuperview().inset(trailingMargin).constraint
            }
        }
        textViewTrailingConstraint?.activate()
    }
    
    @objc func buttonTapped(_ sender: UITapGestureRecognizer){
        guard let button = sender.view as? UIButton else { return }
        let type = ButtonType(rawValue: button.tag)
        switch type{
        case .send:
            self.delegate?.sendButtonTapped(button)
            break
        case .gallery:
            self.delegate?.galleryButtonTapped(button)
            break
        case .youtube:
            self.delegate?.youtubeButtonTapped(button)
            break
        case .none:
            break
        }
    }
}

extension ChatTextView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        var height = estimatedHeight()
        if let lineHeight = textView.font?.lineHeight{
            if height > lineHeight * maxLineCount{
                height = lineHeight * maxLineCount
            }
        }
        
        setTextView()
        
        self.delegate?.setChatTextViewHeight(height)
    }
}
