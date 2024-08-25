//
//  InputTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/4/24.
//

import Foundation
import SnapKit

class InputTextView: UIView{
    var titleLabel = SDGothicLabel()
    var lengthLabel = SDGothicLabel()
    var textView = UITextView()
    var placeHolderLabel = UILabel()
    
    var maxLength = 100
    
    var text: String{
        return self.textView.text ?? ""
    }
    
    var textCount: Int{
        return self.textView.text?.count ?? 0
    }
    
    var lineHeight: CGFloat{
        return self.textView.font?.lineHeight ?? 0
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
        self.backgroundColor = .clear
        
        let inputView = UIView()

        self.addSubview(titleLabel)
        self.addSubview(lengthLabel)
        self.addSubview(inputView)
        inputView.addSubview(textView)
        inputView.addSubview(placeHolderLabel)
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        lengthLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        inputView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            // make.height.equalTo(self.bounds.height * 0.7)
        }
        
        textView.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        placeHolderLabel.snp.makeConstraints{ make in
            make.top.equalTo(textView.snp.top)
            make.leading.equalTo(textView.snp.leading).inset(4)
            make.trailing.equalTo(textView.snp.trailing).inset(4)
        }
        
        titleLabel.setLabel(textColor: .black, fontSize: 13)
        lengthLabel.setLabel(textColor: Colors.gray, fontSize: 13)

        inputView.backgroundColor = Colors.lightGray
        inputView.layer.cornerRadius = 10
        
        textView.font = SDGothic(size: 15)
        textView.textColor = .black
        textView.tintColor = Colors.gray
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        
        placeHolderLabel.font = SDGothic(size: 15)
        placeHolderLabel.textColor = Colors.gray
    }
    
    func setText(title: String, placeHolder: String){
        self.titleLabel.text = title
        self.placeHolderLabel.text = placeHolder
    }
    
    func setText(title: String, placeHolder: String, maxLength: Int){
        self.titleLabel.text = title
        self.placeHolderLabel.text = placeHolder
        self.lengthLabel.text = "0/\(maxLength)"
        self.maxLength = maxLength
    }
    
    func setText(text: String){
        self.textView.text = text
        self.placeHolderLabel.text = ""
        self.lengthLabel.text = "\(text.count)/\(maxLength)"
    }
    
    func setLengthLabel(){
        lengthLabel.text = "\(textView.text?.count ?? 0)/\(maxLength)"
    }
    
    func estimatedHeight()-> CGFloat{
        let maxLine: CGFloat = 4
        return self.frame.height - self.textView.bounds.height + (lineHeight * maxLine)
    }
    
    func setHashTagText(){
        // 텍스트 설정
        let text = textView.text ?? ""
        
        // 정규식을 사용하여 "#"으로 시작하는 단어 찾기
        let pattern = "#\\w+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

        // NSMutableAttributedString을 사용하여 텍스트 속성 설정
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: SDGothic(size: 15), range: NSRange(location: 0, length: text.count))

        for match in matches {
            attributedString.addAttribute(.foregroundColor, value: Colors.skyBlue, range: match.range)
            // attributedString.addAttribute(.backgroundColor, value: Colors.pastelBlue, range: match.range)
        }

        // 속성 텍스트 뷰에 설정
        textView.attributedText = attributedString
    }
    
    func hashTagTextArray() -> [String]{
        let text = textView.text ?? ""
        
        let pattern = "#\\w+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

        return matches.map {
            let range = NSRange(location: $0.range.location + 1, length: $0.range.length - 1)
            return String(text[Range(range, in: text)!])
        }
    }
}

extension InputTextView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count > 0
        setLengthLabel()
        setHashTagText()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 현재 텍스트 길이
        let currentText = textView.text ?? ""
        // 변경될 텍스트 길이
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        // 텍스트 길이 제한 설정
        return updatedText.count <= maxLength
    }
}
