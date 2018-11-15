//
//  UserPreferences.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class UserPreferences {
    
    private let kAutoConfidenceThreshold = "kAutoConfidenceThreshold"
    private let kConfidenceThreshold     = "kConfidenceThreshold"
    
    private let UD = UserDefaults.standard
    
    var autoConfidenceThreshold: Bool {
        get { return UD.bool(forKey: kAutoConfidenceThreshold) }
        set(newValue) { UD.set(newValue, forKey: kAutoConfidenceThreshold) }
    }
    
    var confidenceThreshold: Float {
        get { return UD.float(forKey: kConfidenceThreshold) }
        set(newValue) { UD.set(newValue, forKey: kConfidenceThreshold) }
    }
    
    init() {
        UD.register(defaults: [kAutoConfidenceThreshold : true, kConfidenceThreshold : 0.8])
    }
}
