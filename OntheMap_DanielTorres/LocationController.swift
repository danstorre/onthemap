//
//  LocationController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class LocationController: NSObject {
    
    func getLocations(_ api: LocationsProtocol, numberOFlocationsAsked: Int,  completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ errorString: String?) -> Void){
    
        
        let completionForGettingStudentLocations = { (success: Bool, _ locations: [StudentLocation]?, error: NSError?) -> Void in
            
            if success {
                //If success return list of studentlocations to the completion handler
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

}
