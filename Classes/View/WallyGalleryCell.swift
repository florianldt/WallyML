//
//  WallyGalleryCell.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class WallyGalleryCell: UICollectionViewCell {
    
    static let identifier = "WallyGalleryCell"
    
    let wallyImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(wallyImage)
        
        NSLayoutConstraint.activate([
            wallyImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            wallyImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            wallyImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            wallyImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        self.wallyImage.image = image
    }
}
