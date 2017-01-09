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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var mapDelegate = MapKitViewDelegateOntheMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
        addAnnotions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.displayUserLocation), name: Notification.notificationUpdateUserLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.addAnnotions), name: Notification.notificationRefreshData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        
        locationManager.requestLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        
        locationManager.stopMonitoringSignificantLocationChanges()
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
        performUIUpdatesOnMain {
            self.mapView.setRegion(mkCoordinateRegion, animated: true)
        }
        
    }
    
    // MARK :- Add annotions to mapView
    
    @objc func addAnnotions(){
        
        performUIUpdatesOnMain {
            self.indicator.startAnimating()
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        let apiParse = ParseApi()
        let locationController = Location()
        
        
        locationController.getLocations(apiParse, numberOFlocationsAsked: 100) { (success, listStudentLocations, errorMessage) in
            
            
            guard success else {
                let rootViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController
                
                
                guard let presentedViewController = rootViewController?.presentedViewController else {
                    let reachabilityDidChangeNotification = Notification.Name("ReachabilityDidChangeNotification")
                    NotificationCenter.default.post(name: reachabilityDidChangeNotification, object: nil)
                    return rootViewController!.displayAlert(errorMessage!, completionHandler: {})
                }
                
                performUIUpdatesOnMain {
                    self.indicator.stopAnimating()
                }
                let reachabilityDidChangeNotification = Notification.Name("ReachabilityDidChangeNotification")
                NotificationCenter.default.post(name: reachabilityDidChangeNotification, object: nil)
                return presentedViewController.displayAlert(errorMessage!, completionHandler: {})
            }
            
            guard let listStudentLocations = listStudentLocations else {
                performUIUpdatesOnMain {
                    self.indicator.stopAnimating()
                }
                return self.displayAlert("there are no annotations at the moment", completionHandler: {})
            }
            
            StudentInformation.shared.lastLocations = listStudentLocations
            performUIUpdatesOnMain {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.indicator.stopAnimating()
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

