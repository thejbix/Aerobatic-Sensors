//
//  OffsetData.swift
//  Aerobatic Sensors
//
//  Created by Jaydon Bixenman on 1/20/18.
//  Copyright © 2018 thejbix. All rights reserved.
//

import Foundation
import RealmSwift

class Offsets:Object {
    
    @objc dynamic var pitchOffset:Double = 0.0
    @objc dynamic var rollOffset:Double = 0.0
    @objc dynamic var yawOffset:Double = 0.0
    
}

class OffsetsHelper {
    
    static var realm = try! Realm()
    
    static func deleteAll() {
        let offsets = realm.objects(Offsets.self)
        
        try! realm.write {
            for offset in offsets {
                realm.delete(offset)
            }
        }
    }
    
    static func add(offset: Offsets) {
        try! realm.write {
            realm.add(offset)
        }
    }
    
    static func getAll() -> Results<Offsets> {
        return realm.objects(Offsets.self)
    }
    
}
