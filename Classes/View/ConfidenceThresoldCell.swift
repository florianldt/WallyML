//
//  ConfidenceThresoldCell.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class ConfidenceThresoldCell: UITableViewCell {
    
    static let identifier = "ConfidenceThresoldCell"
    weak var delegate: SettingsViewControllerDelegate?
    
    let confidenceThresoldLabel: UILabel = {
        let label = UILabel()
        label.text = "Confidence Thresold"
        return label
    }()
    
    let confidenceThresoldValue: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let confidenceSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .red
        return slider
    }()
    
    lazy var confidenceLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.addArrangedSubview(confidenceThresoldLabel)
        sv.addArrangedSubview(confidenceThresoldValue)
        return sv
    }()
    
    lazy var confidenceStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.addArrangedSubview(confidenceLabelStackView)
        sv.addArrangedSubview(confidenceSlider)
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(confidenceStackView)
        
        confidenceStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        confidenceStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18).isActive = true
        confidenceStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        confidenceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        confidenceSlider.addTarget(self, action: #selector(updateConfidenceThreshold(sender:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateConfidenceThreshold(sender: UISlider) {
        guard let delegate = delegate else { return }
        let roundedValue: Float =  (roundf(sender.value / 0.05) * 0.05).truncate(places: 2)
        print(roundedValue)
        self.confidenceSlider.value = roundedValue
        self.confidenceThresoldValue.text = "\(roundedValue)"
        delegate.didConfidenceChanged(newConfidence: roundedValue)
        
    }
    
}

