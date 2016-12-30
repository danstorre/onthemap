//
//  Address.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class Address: NSObject {

    var location : LocationAnnotation
    var mapString : String
    
    init(mapString: String, location: LocationAnnotation) {
        self.mapString = mapString
        self.location = location
    }
    
    override init() {
        self.mapString = ""
        self.location = LocationAnnotation()
    }
}
