//
//  StoryboardIdentifiable.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifire: String { get }
}

extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController{
    static var storyboardIdentifire: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(_ :T.Type) -> T {
        guard let viewController =
            self.instantiateViewController(withIdentifier: T.storyboardIdentifire) as? T else {
            fatalError("View controller with identifire \(T.storyboardIdentifire) not found")
        }
        return viewController
    }
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController =
            self.instantiateViewController(withIdentifier: T.storyboardIdentifire) as? T else {
                fatalError("View controller with identifire \(T.storyboardIdentifire) not found")
        }
        return viewController
    }
    
}


