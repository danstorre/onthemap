//
//  Address.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class Address: NSObject {

    var location : Location
    var mapString : String
    
    init(mapString: String, location: Location) {
        self.mapString = mapString
        self.location = location
    }
}

struct Location{

    var latitude : Double
    var longitude : Double
}
