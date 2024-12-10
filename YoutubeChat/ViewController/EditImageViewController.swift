//
//  EditImageViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/5/24.
//

import UIKit

protocol EditImageViewControllerDelegate{
    func didDismissWithImage(image: UIImage?)
}

class EditImageViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var cancelButton: SDGothicButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var fullImageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var pickedImage = UIImage()
    var imageType: ProfileInfoViewController.ImageType?
    var delegate: EditImageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editView.isHidden = imageType == .background
        fullImageView.isHidden = imageType == .profile
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.maskingView.layer.mask = maskLayer()
        
        if imageType == .profile{
            DispatchQueue.main.async{
                self.setImage()
            }
        } else {
            fullImageView.image = pickedImage
        }
    }
    
    private func configureView(){
        imageView.contentMode = .scaleAspectFit
        fullImageView.contentMode = .scaleAspectFit
        
        self.maskingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.maskingView.isUserInteractionEnabled = false
        
        scrollView.backgroundColor = .black
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        cancelButton.tintColor = .white
        confirmButton.tintColor = .white
        
        self.editView.clipsToBounds = true
    }
    
    private func setImage(){
        imageView.image = pickedImage
        
        self.scrollView.zoomScale = 1.0
        
        let width = self.maskingView.bounds.width
        
        if pickedImage.size.width > pickedImage.size.height{
            self.scrollView.clipsToBounds = true
            imageViewWidthConstraint.constant = (pickedImage.size.width * width) / pickedImage.size.height
            imageViewHeightConstraint.constant = width
            
            let centerX = (imageViewWidthConstraint.constant - width) / 2
            self.scrollView.setContentOffset(CGPoint(x: centerX, y: 0), animated: false)
        } else {
            self.scrollView.clipsToBounds = false
            imageViewWidthConstraint.constant = width
            imageViewHeightConstraint.constant = (pickedImage.size.height * width) / pickedImage.size.width
            
            let centerY = (imageViewHeightConstraint.constant - width) / 2
            self.scrollView.setContentOffset(CGPoint(x: 0, y: centerY), animated: false)
        }
    }
    
    private func maskLayer()-> CAShapeLayer{
        let maskingViewWidth = self.view.bounds.width - 10
        let maskingViewHeight = self.maskingView.bounds.height
        
        let rectSize = CGSize(width: maskingViewWidth, height: maskingViewWidth)
        let rectOriginX: CGFloat = 0
        let rectOriginY: CGFloat = (maskingViewHeight / 2) - (maskingViewWidth / 2)
        let rectOrigin = CGPoint(x: rectOriginX, y: rectOriginY)
        let maskRect = CGRect(origin: rectOrigin, size: rectSize)

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(self.maskingView.frame)
        path.addPath(UIBezierPath(roundedRect: maskRect, cornerRadius: maskingViewWidth / 2).cgPath)
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        return maskLayer
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let image = imageType == .profile ? self.captureScrollView() : pickedImage
        self.delegate?.didDismissWithImage(image: image)
    }
    
    private func captureScrollView() -> UIImage? {
        var image: UIImage? = nil
        
        let spacing: CGFloat = 20
        let width = self.view.bounds.width - spacing
        
        let captureRect = CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: width, height: width)
        
        UIGraphicsBeginImageContextWithOptions(captureRect.size, false, 0.0)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -captureRect.origin.x, y: -captureRect.origin.y)
            scrollView.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension EditImageViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
     }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < 1.0 {
            scrollView.setZoomScale(1.0, animated: false) // 즉시 1.0으로 되돌림
        }
    }
}
