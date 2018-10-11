//
//  MapRouter.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import UIKit

final class MapRouter: BaseRouter {
    
    func toLogin(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
