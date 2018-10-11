//
//  UIViewRound.swift
//  geoMap
//
//  Created by Olga Martyanova on 11/10/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit

extension UIImageView {
    func cornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func border(color: UIColor, width: CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
