//
//  EidtProfileTextViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/16/24.
//

import UIKit

protocol EditProfileTextViewControllerDelegate {
  func didEndEdit(_ text: String, _ type: EditProfileTextViewController.ViewType)
}

class EditProfileTextViewController: BaseViewController {
  
  enum ViewType{
    case name, description
  }
  
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var titleLabel: SDGothicLabel!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var textCountLabel: SDGothicLabel!
  
  private var maxCharacterCount = 20
  
  var text: String = ""
  var viewType: ViewType = .name
  
  var delegate: EditProfileTextViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 0.2, animations: {
      self.backgroundView.alpha = 1
    })
    
    textViewHeightConstraint.constant = estimatedHeight()
    textView.becomeFirstResponder()
  }
  
  private func configureView(){
    textView.textAlignment = .center
    textView.backgroundColor = .clear
    textView.tintColor = Colors.lightGray
    textView.textColor = .white
    textView.font = .sdGothic(size: 18)
    
    textView.delegate = self
    
    titleLabel.setLabel(textColor: .white, fontStyle: .semibold,  fontSize: 18)
    
    textView.text = text
    
    textCountLabel.setLabel(textColor: .white, fontSize: 13)
    textCountLabel.text = "\(textView.text.count) / \(maxCharacterCount)"
    
    switch viewType {
    case .name:
      titleLabel.text = "이름"
      maxCharacterCount = 20
    case .description:
      titleLabel.text = "상태메세지"
      maxCharacterCount = 30
    }
    
    backgroundView.alpha = 0
  }
  
  private func estimatedHeight()-> CGFloat{
    let size = CGSize(width: textView.bounds.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    return estimatedSize.height
  }
  
  @IBAction func clearButtonTapped(_ sender: Any) {
    textView.text = ""
    textCountLabel.text = "\(textView.text.count) / \(maxCharacterCount)"
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismissWithAnimation()
  }
  
  @IBAction func confirmButtonTapped(_ sender: Any) {
    self.delegate?.didEndEdit(self.textView.text, self.viewType)
    dismissWithAnimation()
  }
  
  private func dismissWithAnimation(){
    UIView.animate(withDuration: 0.1, animations: {
      self.view.alpha = 0
    }, completion: { _ in
      self.dismiss(animated: false)
    })
  }
}

extension EditProfileTextViewController: UITextViewDelegate{
  func textViewDidChange(_ textView: UITextView) {
    textViewHeightConstraint.constant = estimatedHeight()
    textCountLabel.text = "\(textView.text.count) / \(maxCharacterCount)"
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // 현재 텍스트와 변경될 텍스트를 결합하여 전체 텍스트를 생성합니다.
    let currentText = textView.text ?? ""
    let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
    
    // 새로운 텍스트의 길이를 확인하여 최대 길이를 초과하지 않도록 합니다.
    return newText.count <= maxCharacterCount
  }
}
