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

class EditImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var cancelButton: SDGothicButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var pickedImage = UIImage()
    var delegate: EditImageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImage()
    }
    
    private func configureView(){
        imageView.contentMode = .scaleAspectFit
        
        self.maskingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.maskingView.isUserInteractionEnabled = false
        maskingView.layer.mask = maskLayer()
        
        scrollView.backgroundColor = .black
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        cancelButton.tintColor = Colors.trueBlue
        confirmButton.tintColor = Colors.trueBlue
        
        self.editView.clipsToBounds = true
    }
    
    private func setImage(){
        imageView.image = pickedImage
        
        self.scrollView.zoomScale = 1.0
        
        let spacing: CGFloat = 20
        let width = self.view.bounds.width - spacing
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
        let maskingViewWidth = self.maskingView.bounds.width
        let maskingViewHeight = self.maskingView.bounds.height
        
        let rectSize = CGSize(width: maskingViewWidth, height: maskingViewWidth)
        let rectOriginX: CGFloat = 0
        let rectOriginY: CGFloat = (maskingViewHeight / 2) - (maskingViewWidth / 2)
        let rectOrigin = CGPoint(x: rectOriginX, y: rectOriginY)
        let maskRect = CGRect(origin: rectOrigin, size: rectSize)

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(self.maskingView.convert(self.view.frame, to: nil))
        path.addPath(UIBezierPath(roundedRect: maskRect, cornerRadius: maskingViewWidth / 2).cgPath)
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        return maskLayer
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.delegate?.didDismissWithImage(image: self.captureScrollView())
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
}
