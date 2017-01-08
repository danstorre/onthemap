//
//  LocationController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject {
    
    
    var locationManager: LocationManagerOnTheMap? = LocationManagerOnTheMap()
    let locationDelegate: CLLocationManagerDelegateOnTheMap? = CLLocationManagerDelegateOnTheMap()
    var currentLocation: CLLocation? = nil
    
    // MARK:- Methods
    
    
    func getLocations(_ api: LocationsProtocol, numberOFlocationsAsked: Int,  completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ errorString: String?) -> Void){
    
        
        let completionForGettingStudentLocations = { (success: Bool, _ locations: [StudentLocation]?, error: NSError?) -> Void in
            
            if success {
                //If success return list of studentlocations to the completion handler
                
                StudentInformation.sharedInstance().lastLocations = locations!
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
    

    func getLocation(from userInput: String, inMap mapview: MKMapView, completionHandlerForGetAddress: @escaping (_ success: Bool, _ placeMark: MKPlacemark?, _ errorString: String?) -> Void) {
    
        // Create and initialize a search request object.
        let request : MKLocalSearchRequest = MKLocalSearchRequest()
        request.naturalLanguageQuery = userInput
        request.region = mapview.region
        
        // Create and initialize a search object.
        let localSearch : MKLocalSearch = MKLocalSearch(request: request)
        
        localSearch.start(completionHandler: { (responseLocalSearch) in
            
            guard responseLocalSearch.1 == nil else {
                print(responseLocalSearch.1?.localizedDescription ?? "")
                completionHandlerForGetAddress(false, nil, "Could not load any directions")
                return
            }
            
            mapview.removeAnnotations(mapview.annotations)
            let annotionAddress = responseLocalSearch.0!.mapItems.first!.placemark
            mapview.addAnnotation(annotionAddress)
            let regionToDisplay = MKCoordinateRegionMakeWithDistance(annotionAddress.coordinate, 5000, 5000)
            mapview.setRegion(regionToDisplay, animated: true)
            completionHandlerForGetAddress(true, annotionAddress, nil)
        
        })
        
    }
    
    
    

}


