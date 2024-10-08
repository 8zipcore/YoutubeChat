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
    
    var imageView = UIImageView()
    var label = UILabel()
    
    private let verticalMargin: CGFloat = 5
    private let horizontalMargin: CGFloat = 15
    private let imageViewWidth: CGFloat = 16
    
    var labelLeadingConstraint: Constraint?
    
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
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        
        imageView.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(horizontalMargin)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewWidth)
        }
        
        label.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(verticalMargin)
            make.bottom.equalToSuperview().inset(verticalMargin)
            make.trailing.equalToSuperview().inset(horizontalMargin)
        }
        
        self.backgroundColor = Colors.lightGray
        self.layer.cornerRadius = self.bounds.height / 2
        label.font = SDGothic(size: 14)
        label.textColor = Colors.gray
        label.textAlignment = .center
        
        isSelected = false
        imageView.isHidden = true
    }
    
    func configureView(image: UIImage?, title: String, isSelected: Bool){
        labelLeadingConstraint?.deactivate()
        
        self.label.text = title
        
        var margin: CGFloat = horizontalMargin
        var labelColor = isSelected ? .black : Colors.white
        var backgroundColor = isSelected ? Colors.white : .init(white: 1, alpha: 0.05)
        var borderColor = isSelected ? Colors.white : .init(white: 1, alpha: 0.1)
        
        imageView.isHidden = (image == nil)
        
        // 첫번째 검색일 때
        if let image = image {
            imageView.image = image
            let spacing: CGFloat = 5
            margin = imageViewWidth + horizontalMargin + spacing
            backgroundColor = Colors.indigo
            labelColor = .white
            borderColor = Colors.borderIndigo
        }
        
        self.backgroundColor = backgroundColor
        self.label.textColor = labelColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.5
        
        label.snp.makeConstraints{
            self.labelLeadingConstraint = $0.leading.equalToSuperview().inset(margin).constraint
        }
        
        labelLeadingConstraint?.isActive = true
    }
    
    func setText(text: String){
        self.label.text = text
        self.label.layoutIfNeeded()
    }
}

extension ChatOptionCollectionViewCell{
    static func fittingSize(cellHeight: CGFloat, image: UIImage? ,title: String, isSelected: Bool) -> CGSize {
        let cell = ChatOptionCollectionViewCell()
        cell.configureView(image: image, title: title, isSelected: isSelected)
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
