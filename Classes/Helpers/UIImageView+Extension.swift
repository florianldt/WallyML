//
//  UIImageView+Extension.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

extension UIImageView {
    func getCurrentImageSize() -> ImageSize {
        guard let image = self.image else {
            return ImageSize(width: 0, height: 0)
        }
        let width = image.size.width * image.scale
        let height = image.size.height * image.scale
        return ImageSize(width: width, height: height)
    }
    
    func addBoundingBoxes(_ boxes: [Box]) {
        for box in boxes.reversed() {
            let view = UIView(frame: box.rect)
            view.layer.borderColor = UIColor.green.cgColor
            view.layer.borderWidth = 6.0
            self.addSubview(view)
            let confidenceLabel = UILabel()
            let confidence = Int((box.confidence*100.0).rounded())
            confidenceLabel.text = "waldo: \(confidence)%"
            confidenceLabel.textAlignment = .center
            confidenceLabel.frame = CGRect(x: box.x, y: box.y - 15, width: 0, height: 0)
            confidenceLabel.font = UIFont.boldSystemFont(ofSize: 10)
            confidenceLabel.sizeToFit()
            confidenceLabel.frame.size.height = 20
            confidenceLabel.frame.size.width = confidenceLabel.frame.size.width + 10
            confidenceLabel.backgroundColor = .green
            self.addSubview(confidenceLabel)
        }
    }
}

