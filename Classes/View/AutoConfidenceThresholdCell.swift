//
//  AutoConfidenceThresholdCell.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class AutoConfidenceThresholdCell: UITableViewCell {
    
    static let identifier = "AutoConfidenceThresholdCell"
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let autoConfidenceThresholdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Auto Confidence Threshold"
        return label
    }()
    
    let autoConfidenceThresholdSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.onTintColor = .red
        
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(autoConfidenceThresholdLabel)
        contentView.addSubview(autoConfidenceThresholdSwitch)
        
        autoConfidenceThresholdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        autoConfidenceThresholdLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18).isActive = true
        autoConfidenceThresholdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100).isActive = true
        autoConfidenceThresholdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        autoConfidenceThresholdSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        autoConfidenceThresholdSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        
        autoConfidenceThresholdSwitch.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchValueChanged(sender: UISwitch) {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.didSwitchChange(isOn: sender.isOn)
    }
    
}

