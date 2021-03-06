//
//  Pin.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

struct Pin {
    var mediaURL : String
    var address : Address
    var user : User
    
    init(mediaURL: String, user: User, address: Address){
    
        self.mediaURL = mediaURL
        self.user = user
        self.address = address
    }
    
    init() {
        self.mediaURL = ""
        self.user = User()
        self.address = Address()
    }
}
