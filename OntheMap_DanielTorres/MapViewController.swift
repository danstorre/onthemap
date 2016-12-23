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
        let notificationUpdateUserLocation = Notification.Name("updateUserLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.displayUserLocation), name: notificationUpdateUserLocation, object: nil)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let locationManager = appDelegate.locationController.locationManager else {
            return
        }

        locationManager.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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

