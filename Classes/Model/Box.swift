//
//  Box.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

struct Box {
    let x: CGFloat
    let y: CGFloat
    let height: CGFloat
    let width: CGFloat
    let confidence: Float
    
    init(rect: CGRect, originalImageSize: ImageSize, confidence: Float) {
        x = rect.minX * originalImageSize.width
        y = rect.minY * originalImageSize.height
        height = rect.height * originalImageSize.height
        width = rect.width * originalImageSize.width
        self.confidence = confidence
    }
    
    var rect: CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
