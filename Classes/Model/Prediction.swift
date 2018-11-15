//
//  Prediction.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

struct Prediction {
    let labelIndex: Int
    let confidence: Float
    let boundingBox: CGRect
}
