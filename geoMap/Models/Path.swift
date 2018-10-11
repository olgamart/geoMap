//
//  Path.swift
//  geoMap
//
//  Created by Olga Martyanova on 20/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import RealmSwift

class Path: Object {
    @objc dynamic var path: String = ""
    
    convenience init(path: String) {
        self.init()
        self.path = path
    }
}


