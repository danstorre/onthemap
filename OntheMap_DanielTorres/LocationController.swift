//
//  LocationController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class LocationController: NSObject {
    
    
    var locationManager: LocationManagerOnTheMap? = LocationManagerOnTheMap()
    let locationDelegate: CLLocationManagerDelegateOnTheMap? = CLLocationManagerDelegateOnTheMap()
    var lastLocations: [StudentLocation] = [StudentLocation]()
    var currenLocation: CLLocation? = nil
    
    
    func getLocations(_ api: LocationsProtocol, numberOFlocationsAsked: Int,  completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ errorString: String?) -> Void){
    
        
        let completionForGettingStudentLocations = { (success: Bool, _ locations: [StudentLocation]?, error: NSError?) -> Void in
            
            if success {
                //If success return list of studentlocations to the completion handler
                self.lastLocations = locations!
                completionHandlerForGettingLocations(true, locations, nil)
            }
            else {
                print(error!)
                completionHandlerForGettingLocations(false, nil, "Could not retrieve stutendts locations please try again")
            }
        }
        
        api.getLastLocations(numberOfLocations: String(numberOFlocationsAsked), completionHandlerForGettingLocations:
            completionForGettingStudentLocations)
    }
    
    func postLocation(_ api: LocationsProtocol, studentLocationToPost: StudentLocation,  completionHandlerForPostingLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let completionHandlerForPostLocation = { (success: Bool, error: NSError?) -> Void in
            
            if success {
                //If success return list of studentlocations to the completion handler
                completionHandlerForPostingLocation(true, nil)
            }
            else {
                print(error!)
                completionHandlerForPostingLocation(false, "Could not post your locations please try again")
            }
        }
        api.postStudentLocation(studentLocationToPost: studentLocationToPost, completionHandlerForPostingLocation: completionHandlerForPostLocation)
    }
    
    
    

}


