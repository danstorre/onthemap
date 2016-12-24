//
//  StudentLocation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import CoreLocation

class StudentLocation: NSObject {

    var objectId: String
    var uniqueKey: String?
    var pin: Pin?
    
    
    init(objectId: String, uniquekey: String, pin: Pin){
        self.objectId = objectId
        self.uniqueKey = uniquekey
        self.pin = pin
    }
    
    init(dictionary: [String:AnyObject]){
        objectId = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.objectId] as! String
        
        if let uniqueKey = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.uniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        
        guard let mapString = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.mapString] as? String else {
            return
        }
        
        guard let latitude = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.latitude] as? Double, let longitude = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.longitude] as? Double else {
            return
        }
        
        let coordinate2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = LocationAnnotation(coordinate: coordinate2d)
        let address = Address(mapString: mapString, location: location)
        
        guard let firstName = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.firstName] as? String,
            let lastName = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.lastName] as? String else {
            return
        }
        
        let user = User(firstName: firstName, lastName: lastName)
        
        guard let mediaUrl = dictionary[ConstantsLocation.JSONBodyResponseParseKeys.mediaURL] as? String else {
            return
        }
        
        pin = Pin(mediaURL: mediaUrl, user: user, address: address)
    }
    
    
    class func arrayOfStudentLocations(from dictionary: [[String:AnyObject]]) -> [StudentLocation]{
        var studentLocationsToReturn = [StudentLocation]()
        
        for studentlocation in dictionary{
            studentLocationsToReturn.append(StudentLocation(dictionary: studentlocation))
        }
        
        return studentLocationsToReturn
    
    }
}

