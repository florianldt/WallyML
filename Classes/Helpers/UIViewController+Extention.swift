//
//  UIViewController+Extention.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayBasicAlert(withTitle title: String?, andMessage message: String?) {
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}
