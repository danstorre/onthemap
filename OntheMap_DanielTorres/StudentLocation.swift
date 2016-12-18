//
//  StudentLocation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class StudentLocation: NSObject {

    var objectId: String
    var uniqueKey: String
    var pin: Pin
    
    
    init(objectId: String, uniquekey: String, pin: Pin){
        self.objectId = objectId
        self.uniqueKey = uniquekey
        self.pin = pin
    }
}

