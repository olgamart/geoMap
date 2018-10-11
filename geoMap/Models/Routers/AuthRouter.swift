//
//  AuthRouter.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import UIKit

final class AuthRouter: BaseRouter {
    func toLogin(controller: UIViewController, user: User) {
        
        controller.dismiss(animated: true, completion: nil)
        
        if let viewConnroller = controller.presentingViewController as? LoginViewController {
            viewConnroller.newUser = user
        }
    }
}
