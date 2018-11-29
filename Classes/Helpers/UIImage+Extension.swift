//
//  UIImage+Extension.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

func imagesFromFolder(_ folder: String) -> [UIImage] {
    if let path = Bundle.main.resourcePath {
        
        let imagePath = path + "/\(folder)"
        let url = NSURL(fileURLWithPath: imagePath)
        let fileManager = FileManager.default
        
        let properties = [URLResourceKey.localizedNameKey,
                          URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
        
        do {
            let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            
            var imgArray = [UIImage]()
            
            // Create image from URL
            for imageURL in imageURLs {
                let myImage =  UIImage(data: try Data(contentsOf: imageURL))
                if let image = myImage {
                    imgArray.append(image)
                }
                
            }
            
            return imgArray
            
        } catch let error1 as NSError {
            print(error1.description)
        }
    }
    
    fatalError("Bundle.main.resourcePath")
    
}

extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
