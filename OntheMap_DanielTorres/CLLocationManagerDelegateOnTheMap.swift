//
//  OnTheMapCLLocationManagerDelegate.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/22/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class CLLocationManagerDelegateOnTheMap: NSObject, CLLocationManagerDelegate  {

    
    
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations: [CLLocation]){
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.locationController.currentLocation = didUpdateLocations.last
        
        let notificationUpdateUserLocation = Notification.Name("updateUserLocation")
        NotificationCenter.default.post(name: notificationUpdateUserLocation, object: nil)

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == CLAuthorizationStatus.authorizedWhenInUse && CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            return
        }
        
        manager.startMonitoringSignificantLocationChanges()
        
        
    }
    
    
}
