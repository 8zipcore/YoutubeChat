//
//  ImageViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/24/24.
//

import UIKit

class ImageViewController: BaseViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var image: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  private func configureView(){
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
  }
  
  @IBAction func dimissButtonTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
}
