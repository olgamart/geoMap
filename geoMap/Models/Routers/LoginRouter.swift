//
//  LoginRouter.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import UIKit

final class LoginRouter: BaseRouter {
    func toMap() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MapViewController.self)
        let navigationController = UINavigationController(rootViewController: controller)
        show(navigationController)
    }
    
    func toAuth() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(AuthViewController.self)
        let navigationController = UINavigationController(rootViewController: controller)
        show(navigationController)
    }
}
