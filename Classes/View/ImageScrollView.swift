//
//  ImageScrollView.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

final class ImageScrollView: UIScrollView {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var imageViewBottomConstraint = NSLayoutConstraint()
    private var imageViewLeadingConstraint = NSLayoutConstraint()
    private var imageViewTopConstraint = NSLayoutConstraint()
    private var imageViewTrailingConstraint = NSLayoutConstraint()
    
    required init(image: UIImage) {
        super.init(frame: .zero)
        
        updateImage(with: image)
        NSLayoutConstraint.activate([imageViewLeadingConstraint, imageViewTrailingConstraint, imageViewTopConstraint, imageViewBottomConstraint])
        
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = true
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        delegate = self
        backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    func setZoomScale() {
        let widthScale = frame.size.width / imageView.bounds.width
        let heightScale = frame.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
        maximumZoomScale = 5.0
    }
    
    func updateImage(with image: UIImage) {
        imageView.image = image
        addSubview(imageView)
        imageView.sizeToFit()
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    }
    
    func getCurrentImage() -> UIImage? {
        return self.imageView.image
    }
    
    func clearBoundingBoxes() {
        imageView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
    
    func hideBoundingBox() {
        self.imageView.subviews.forEach { (subview) in
            subview.isHidden = true
        }
    }
    
    func showBoundingBox() {
        self.imageView.subviews.forEach { (subview) in
            subview.isHidden = false
        }
    }
    
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let yOffset = max(0, (bounds.size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (bounds.size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        layoutIfNeeded()
    }
    
}

