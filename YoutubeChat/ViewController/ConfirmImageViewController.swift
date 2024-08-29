//
//  ConfirmImageViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 8/4/24.
//

import UIKit

class ConfirmImageViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var pickedImage = UIImage()
    var delegate: EditImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = pickedImage
    }

    private func configureView(){
        imageView.contentMode = .scaleAspectFit
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.delegate?.didDismissWithImage(image: pickedImage)
    }
    
}
