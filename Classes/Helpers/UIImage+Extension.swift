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
