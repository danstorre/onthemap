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
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }
        locationManager.configureLocationManager()
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.displayUserLocation), name: Notification.notificationUpdateUserLocation, object: nil)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    // MARK :- Display User
    
    @objc func displayUserLocation(){
    
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            return
        }
        
        guard let currenLocation = appDelegate.locationController.currenLocation else {
            return
        }
        
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(currenLocation.coordinate, 5000, 5000)
        mapView.setRegion(mkCoordinateRegion, animated: true)
        
    }
    
}

