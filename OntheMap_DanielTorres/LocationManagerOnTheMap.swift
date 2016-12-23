//
//  OnTheMapLocationManager.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/22/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class LocationManagerOnTheMap: CLLocationManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func configureLocationManager(){
            
            guard let locationManager = appDelegate.locationController.locationManager else {
                return
            }
            
            guard let locationDelegate = appDelegate.locationController.locationDelegate else {
                return
            }
            
            locationManager.delegate = locationDelegate
            
            guard CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted &&
                CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied else  {
                    return
            }
            
            guard CLLocationManager.authorizationStatus() != CLAuthorizationStatus.notDetermined else {
                locationManager.requestWhenInUseAuthorization()
                return
            }
            
            locationManager.startMonitoringSignificantLocationChanges()
    }
    
}
