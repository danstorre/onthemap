//
//  ConstantsLocation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class ConstantsLocation: NSObject {

    // MARK: Constants
    struct ParseConstants {
        
        // MARK: URLs
        static let apiScheme = "https"
        static let apiHost = "parse.udacity.com"
        
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    // MARK: Methods
    struct Methods {
        static let parseStudentsLocations = "/parse/classes/StudentLocation"
    }
    
    struct UrlKeys {
        // Locations
        static let limit = "limit"
        static let skip = "skip"
        static let decending = "skip"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyParseKeys {
        
        
    }
    
    // MARK: JSON Body Response Keys
    struct JSONBodyResponseParseKeys {
        
        
    }
}
