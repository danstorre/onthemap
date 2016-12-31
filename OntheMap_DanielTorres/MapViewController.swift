//
//  MapViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/20/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var mapView: MKMapView!
    var mapDelegate = MapKitViewDelegateOntheMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.displayUserLocation), name: Notification.notificationUpdateUserLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.addAnnotions), name: Notification.notificationRefreshData, object: nil)
        
        addAnnotions()
        
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        
        locationManager.requestLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.notificationUpdateUserLocation, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.notificationRefreshData, object: nil)
        
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


// MARK :- Helper methods
private extension MapViewController {

    func configureMap(){
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.delegate = mapDelegate
        mapView.showsUserLocation = true
    }
    
    func configureLocationManager(){
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        
        locationManager.configureLocationManager()
    }
    
    // MARK :- Display User
    
    @objc func displayUserLocation(){
    
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            return
        }
        
        guard let currenLocation = appDelegate.locationController.currentLocation else {
            return
        }
        
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(currenLocation.coordinate, 5000000, 5000000)
        mapView.setRegion(mkCoordinateRegion, animated: true)
        
    }
    
    // MARK :- Add annotions to mapView
    
    @objc func addAnnotions(){
        
        mapView.removeAnnotations(mapView.annotations)
        let apiParse = ParseApiController()
        let locationController = LocationController()
        
        locationController.getLocations(apiParse, numberOFlocationsAsked: 100) { (success, listStudentLocations, errorMessage) in
            
            
            guard success else {
                return self.displayAlert(errorMessage!, completionHandler: {})
            }
            
            guard let listStudentLocations = listStudentLocations else {
                return self.displayAlert("there are no annotations at the moment", completionHandler: {})
            }
            
            self.appDelegate.locationController.lastLocations = listStudentLocations
            performUIUpdatesOnMain {
                for studentLocation in listStudentLocations {
                    
                    
                    guard let pin = studentLocation.pin else {
                        continue
                    }
                    let annotation = pin.address.location
                    annotation.title = pin.user.firstName + " " + pin.user.lastName
                    annotation.subtitle = pin.mediaURL
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
           
        }
    }
    
}

