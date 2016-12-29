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
    
    func getStudentLocation(_ api: LocationsProtocol, uniqueKeyAccount: String, completionHandlerForGettingLocation: @escaping (StudentLocation?, String?) -> Void) {
        
        let completionHandlerAPIForGettingLocation = { (studentLocation: StudentLocation?, error: NSError?) -> Void in
            
            guard error == nil else {
                print(error!.description)
                return completionHandlerForGettingLocation(nil, "Could not locate any Student with unique Key : \(uniqueKeyAccount)")
            }
            
            completionHandlerForGettingLocation(studentLocation, nil)
        }
        api.getStudentLocation(uniqueKeyAccount: uniqueKeyAccount, completionHandlerForGettingLocation: completionHandlerAPIForGettingLocation)
    }
    
    
    

}


