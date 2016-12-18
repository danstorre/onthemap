//
//  ConstantsAuthentication.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/15/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class Authentication: NSObject {
    
    // MARK: Constants
    struct UdacityConstants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let udacitySessionPath = "/api/session"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyUdacityKeys {
        
        // Login
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        
    }
    
    // MARK: JSON Body Response Keys
    struct JSONBodyResponseUdacityKeys {
        
        // Login
        static let session = "session"
        static let id = "id"
        
    }
}
