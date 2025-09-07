//
//  ImageChatWithProfileTableViewCell.swift
//  YoutubeChat
//
//  Created by 홍승아 on 6/28/24.
//

import UIKit

class ImageChatWithProfileTableViewCell: UITableViewCell {
  
  static let identifier = "ImageChatWithProfileTableViewCell"
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: SDGothicLabel!
  @IBOutlet weak var imageChatView: ImageChatView!
  
  @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageChatViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageChatViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureView()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageChatView.setImage(image: nil)
  }
  
  private func configureView(){
    self.backgroundColor = .clear
    
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
    
    nameLabel.setLabel(textColor: .white, fontSize: 13)
    nameLabelHeightConstraint.constant = self.bounds.height * 0.1
    
    nameLabel.text = "리코"
    profileImageView.image = UIImage(named: "riku")
  }
  
  func setImage(image: UIImage, profileHidden: Bool){
    self.imageChatView.setImage(image: image)
  }
  
  private func setImageSize(image: UIImage?)-> CGSize{
    // ⭐️ 사이즈 바꾸면 테이블 뷰 재사용 관련 오류 나는거 해결하기
    guard let image = image else { return .zero}
    
    let size = image.size
    
    let maxWidth = self.bounds.width * 0.7
    let minWidth = maxWidth * 0.85
    
    // 기종별 화면 비율로 바꾸기
    let maxHeight: CGFloat = (maxWidth * 16) / 9
    let minHeight: CGFloat = maxHeight * 0.3
    
    var imageWidth: CGFloat = size.width
    var imageHeight: CGFloat = size.height
    
    if imageWidth > maxWidth {
      imageWidth = maxWidth
      imageHeight = (size.height * imageWidth) / size.width
      
      if imageHeight < minHeight {
        imageWidth = maxWidth
        imageHeight = minHeight
      }
    }
    
    if imageHeight > maxHeight {
      imageHeight = maxHeight
      imageWidth = (size.width * imageHeight) / size.height
      
      if imageWidth < minWidth {
        imageWidth = minWidth
        imageHeight = maxHeight
      }
    }
    
    return CGSize(width: imageWidth, height: imageHeight)
  }
  
  func estimatedHeight(image: UIImage, profileHidden: Bool)-> CGFloat{
    let size = setImageSize(image: image)
    let spacing: CGFloat = 10
    return nameLabelHeightConstraint.constant + size.height + spacing
  }
}

