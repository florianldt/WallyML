//
//  SettingsViewController.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func didSwitchChange(isOn: Bool)
    func didConfidenceChanged(newConfidence: Float)
}

class SettingsViewController: UIViewController {
    
    let userPreferences: UserPreferences
    
    private enum settings: Int {
        case autoConfidenceThreshold, confidenceThreshold
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(AutoConfidenceThresholdCell.self, forCellReuseIdentifier: AutoConfidenceThresholdCell.identifier)
        tv.register(ConfidenceThresoldCell.self, forCellReuseIdentifier: ConfidenceThresoldCell.identifier)
        return tv
    }()
    
    init(preferences: UserPreferences = UserPreferences()) {
        self.userPreferences = preferences
        super.init(nibName: nil, bundle: nil)
        title = "Settings"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .lightGray
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPreferences.autoConfidenceThreshold ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell: UITableViewCell
        switch settings(rawValue: indexPath.row)! {
        case .autoConfidenceThreshold:
            let cell = tableView.dequeueReusableCell(withIdentifier: AutoConfidenceThresholdCell.identifier, for: indexPath) as! AutoConfidenceThresholdCell
            cell.autoConfidenceThresholdSwitch.isOn = userPreferences.autoConfidenceThreshold
            cell.delegate = self
            returnCell = cell
        case .confidenceThreshold:
            let cell = tableView.dequeueReusableCell(withIdentifier: ConfidenceThresoldCell.identifier, for: indexPath) as! ConfidenceThresoldCell
            cell.confidenceSlider.value = userPreferences.confidenceThreshold
            cell.confidenceThresoldValue.text = "\(userPreferences.confidenceThreshold)"
            cell.delegate = self
            returnCell = cell
        }
        return returnCell
    }
    
    
}

extension SettingsViewController: SettingsViewControllerDelegate {
    
    func didSwitchChange(isOn: Bool) {
        userPreferences.autoConfidenceThreshold = isOn
        let confidenceThresholdIndexPath = IndexPath(item: 1, section: 0)
        if isOn {
            userPreferences.confidenceThreshold = 0.8
            tableView.deleteRows(at: [confidenceThresholdIndexPath], with: .automatic)
        } else {
            tableView.insertRows(at: [confidenceThresholdIndexPath], with: .automatic)
        }
        
    }
    
    func didConfidenceChanged(newConfidence: Float) {
        userPreferences.confidenceThreshold = newConfidence
        
    }
}

