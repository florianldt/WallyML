//
//  ConfidenceView.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class ConfidenceView: UIView {
    
    let confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        alpha = 0.6
        
        addSubview(confidenceLabel)
        confidenceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        confidenceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        confidenceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        confidenceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

