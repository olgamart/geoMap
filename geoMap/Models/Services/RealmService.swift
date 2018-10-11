//
//  RealmService.swift
//  geoMap
//
//  Created by Olga Martyanova on 20/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    class func saveData (saveObjects: Object, type: Object.Type){
        
        do {
            //         let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //         let realm = try Realm(configuration: config)
            let realm = try! Realm()
            let oldData = realm.objects(type)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(saveObjects)
            try realm.commitWrite()            
        } catch {
            print(error)
        }    
    }
    
    class func loadData(type: Object.Type) -> Object{
        let realm = try! Realm()
        let loadObjects = realm.objects(type).first
        return loadObjects ?? Object()
        
    }
    
    class func saveUser (saveObject: Object){        
        do {
            let realm = try! Realm()
            realm.beginWrite()
            realm.add(saveObject)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    class func findUser(type: Object.Type, userLogin: String) -> Object{
        let realm = try! Realm()
        let loadObjects = realm.objects(type).filter("login = '\(userLogin)'").first
        return loadObjects ?? Object()
    }
    
    class func setPassword (saveObject: User, savePassword: String){
        do {
            let realm = try! Realm()
            realm.beginWrite()
            saveObject.password = savePassword            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
