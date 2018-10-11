//
//  UIImageResize.swift
//  geoMap
//
//  Created by Olga Martyanova on 11/10/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImageWith(sizeMax: CGFloat) -> UIImage {       
        
        let horizontalRatio = sizeMax / self.size.width
        let verticalRatio = sizeMax / self.size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        var newImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
