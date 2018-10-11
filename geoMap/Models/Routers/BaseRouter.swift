//
//  BaseRouter.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import UIKit

class BaseRouter: NSObject {
    @IBOutlet weak var controller: UIViewController!
    
    func show(_ controller: UIViewController){
        self.controller.show(controller, sender: nil)
    }
    
    func present(_ controller: UIViewController){
        self.controller.present(controller, animated: true)
    }
    func setAsRoot(_ controller: UIViewController){
        UIApplication.shared.delegate?.window??.rootViewController = controller
    }
}
