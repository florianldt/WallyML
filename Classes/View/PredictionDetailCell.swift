//
//  PredictionDetailCell.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class PredictionDetailCell: UICollectionViewCell {
    
    static let identifier = "PredictionDetailCell"
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let boundingBoxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(indexLabel)
        contentView.addSubview(confidenceLabel)
        contentView.addSubview(boundingBoxLabel)
        
        indexLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        indexLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18).isActive = true
        indexLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        indexLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        confidenceLabel.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 0).isActive = true
        confidenceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18).isActive = true
        confidenceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        confidenceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        boundingBoxLabel.topAnchor.constraint(equalTo: confidenceLabel.bottomAnchor, constant: 0).isActive = true
        boundingBoxLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18).isActive = true
        boundingBoxLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        boundingBoxLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with model: Prediction) {
        
        let indexLabelTitle = NSAttributedString(string: "Label index:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        let indexLabelValue = NSAttributedString(string: " \(model.labelIndex)")
        let indexLabelText: NSMutableAttributedString = NSMutableAttributedString()
        indexLabelText.append(indexLabelTitle)
        indexLabelText.append(indexLabelValue)
        indexLabel.attributedText = indexLabelText
        
        let confidenceLabelTitle = NSAttributedString(string: "Confidence:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        let confidenceLabelValue = NSAttributedString(string: " \(model.confidence)")
        let confidenceLabelText: NSMutableAttributedString = NSMutableAttributedString()
        confidenceLabelText.append(confidenceLabelTitle)
        confidenceLabelText.append(confidenceLabelValue)
        confidenceLabel.attributedText = confidenceLabelText
        
        let boundingBoxTitle = NSAttributedString(string: "Bounding box:", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        let boundingBoxValue = NSAttributedString(string: "\n   x: \(model.boundingBox.origin.x)\n   y:  \(model.boundingBox.origin.y)\n   width:  \(model.boundingBox.size.width)\n   height:  \(model.boundingBox.height)")
        let boundingBoxText: NSMutableAttributedString = NSMutableAttributedString()
        boundingBoxText.append(boundingBoxTitle)
        boundingBoxText.append(boundingBoxValue)
        boundingBoxLabel.attributedText = boundingBoxText
    }
    
    
}

