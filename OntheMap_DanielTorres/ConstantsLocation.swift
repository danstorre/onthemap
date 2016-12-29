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
        static let order = "order"
        static let descending = "-"
        static let ascending = ""
        
        // Getting a student Location 
        static let whereKey = "where"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyParseKeys {
        static let updateAt = "updateAt"
        static let uniqueKey = "uniqueKey"
        
    }
    
    // MARK: JSON Body Response Keys
    struct JSONBodyResponseParseKeys {
        
        //List Student Locations
        static let results = "results"
        
        //Student Location
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
        
    }
}
