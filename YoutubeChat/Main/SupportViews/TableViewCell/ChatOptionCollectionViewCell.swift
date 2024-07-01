//
//  ChatOptionCollectionViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/21/24.
//

import UIKit
import SnapKit

class ChatOptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChatOptionCollectionViewCell"
    
    var label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(){
        self.contentView.addSubview(label)
        
        let verticalMargin: CGFloat = 5
        let horizontalMargin: CGFloat = 15
        
        label.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(verticalMargin)
            make.bottom.equalToSuperview().inset(verticalMargin)
            make.leading.equalToSuperview().inset(horizontalMargin)
            make.trailing.equalToSuperview().inset(horizontalMargin)
        }
        
        self.backgroundColor = Colors.lightGray
        self.layer.cornerRadius = self.bounds.height / 2
        label.font = SDGothicSemiBold(size: 13)
        label.textColor = Colors.gray
        label.textAlignment = .center
        
        isSelected = false
    }
    
    func configureView(_ data: ChatOptionData){
        self.label.text = data.title

        self.backgroundColor = data.isSelected ? Colors.trueBlue : Colors.lightGray
        self.label.textColor = data.isSelected ? Colors.white : Colors.gray
    }
    
    func setText(text: String){
        self.label.text = text
        self.label.layoutIfNeeded()
    }
}

extension ChatOptionCollectionViewCell{
    static func fittingSize(cellHeight: CGFloat, data: ChatOptionData) -> CGSize {
        let cell = ChatOptionCollectionViewCell()
        cell.configureView(data)
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: cellHeight)
        let cellWidth = cell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required).width
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
