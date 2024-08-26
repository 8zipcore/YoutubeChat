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
        label.font = SDGothicSemiBold(size: 14)
        label.textColor = Colors.gray
        label.textAlignment = .center
        
        isSelected = false
        imageView.isHidden = true
    }
    
    func configureView(image: UIImage?, title: String, isSelected: Bool){
        labelLeadingConstraint?.deactivate()
        
        imageView.isHidden = (image == nil)
        
        var margin: CGFloat = horizontalMargin
        
        if let image = image {
            imageView.image = image
            let spacing: CGFloat = 5
            margin = imageViewWidth + horizontalMargin + spacing
        }
        
        label.snp.makeConstraints{
            self.labelLeadingConstraint = $0.leading.equalToSuperview().inset(margin).constraint
        }
        
        labelLeadingConstraint?.isActive = true
        
        self.label.text = title

        self.backgroundColor = isSelected ? Colors.blue : Colors.lightGray
        self.label.textColor = isSelected ? Colors.white : Colors.gray
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
