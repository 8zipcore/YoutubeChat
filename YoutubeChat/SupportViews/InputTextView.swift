//
//  InputTextView.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/4/24.
//

import Foundation
import SnapKit

@objc protocol InputTextViewDelegate{
    @objc optional func textViewDidBeginEditing(_ sender: InputTextView)
}

class InputTextView: UIView, ClearButtonDelegate{
    var titleLabel = SDGothicLabel()
    var lengthLabel = SDGothicLabel()
    var textView = UITextView()
    var placeHolderLabel = UILabel()
    var clearButton = ClearButton()
    var contentView = UIView()
    
    var maxLength = 100
    
    var text: String{
        return self.textView.text ?? ""
    }
    
    var textCount: Int{
        return self.textView.text.utf16.count 
    }
    
    var lineHeight: CGFloat{
        return self.textView.font?.lineHeight ?? 0
    }
    
    var delegate: InputTextViewDelegate?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clearButton.snp.makeConstraints{ make in
            make.width.equalTo(self.bounds.width * 0.05)
            make.height.equalTo(self.bounds.width * 0.05)
        }
    }
    
    private func configureView(){
        self.backgroundColor = .clear

        self.addSubview(titleLabel)
        self.addSubview(lengthLabel)
        self.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(placeHolderLabel)
        contentView.addSubview(clearButton)
        
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
        
        contentView.snp.makeConstraints{ make in
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
        }
        
        placeHolderLabel.snp.makeConstraints{ make in
            make.top.equalTo(textView.snp.top)
            make.leading.equalTo(textView.snp.leading).inset(4)
            make.trailing.equalTo(textView.snp.trailing).inset(4)
        }
        
        clearButton.snp.makeConstraints{ make in
            make.leading.equalTo(textView.snp.trailing).inset(-5)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(15)
        }
        
        titleLabel.setLabel(textColor: .white, fontSize: 13)
        lengthLabel.setLabel(textColor: Colors.gray, fontSize: 13)

        contentView.backgroundColor = Colors.backgroundWhite
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = Colors.borderGray.cgColor
        contentView.layer.borderWidth = 1.5
        
        textView.font = SDGothic(size: 15)
        textView.tintColor = Colors.gray
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        
        placeHolderLabel.font = SDGothic(size: 15)
        placeHolderLabel.textColor = Colors.gray
        
        clearButton.delegate = self
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
        setLengthLabel()
        setHashTagText()
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
        let textCount = text.utf16.count // emoji가 UTF-16 길이를 기반으로해서

        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: textCount))

        // NSMutableAttributedString을 사용하여 텍스트 속성 설정
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: SDGothic(size: 15), range: NSRange(location: 0, length: textCount))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: textCount))

        for match in matches {
            attributedString.addAttribute(.foregroundColor, value: Colors.blue, range: match.range)
            // attributedString.addAttribute(.backgroundColor, value: Colors.pastelBlue, range: match.range)
        }

        // 속성 텍스트 뷰에 설정
        textView.attributedText = attributedString
    }
    
    func hashTagTextArray() -> [String]{
        let text = textView.text ?? ""
        
        let pattern = "#\\w+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: textCount))

        return matches.map {
            let range = NSRange(location: $0.range.location + 1, length: $0.range.length - 1)
            return String(text[Range(range, in: text)!])
        }
    }
    
    func clearButtonTapped() {
        textView.text = ""
        textViewDidChange(textView)
    }
}

extension InputTextView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count > 0
        clearButton.isHidden = !(textView.text.count > 0)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.contentView.backgroundColor = .init(white: 1, alpha: 0.15)
        delegate?.textViewDidBeginEditing?(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.contentView.backgroundColor = Colors.backgroundWhite
    }
}
