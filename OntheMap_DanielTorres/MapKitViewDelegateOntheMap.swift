//
//  OntheMapKitViewDelegate.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/20/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewDelegateOntheMap: NSObject, MKMapViewDelegate {
    
    var annotationIdentifier = "annotionView"
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotionView")
        guard annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        guard annotation.isKind(of: LocationAnnotation.self) else {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        guard annotationView == nil else {
            return annotationView
        }
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        pinAnnotationView.pinTintColor = UIColor.red
        pinAnnotationView.animatesDrop = true
        pinAnnotationView.canShowCallout = true
        
        let rightButtonAccessory = UIButton(type: .detailDisclosure)
        rightButtonAccessory.addTarget(self, action: #selector(accessHtmlLink), for: UIControlEvents.touchUpInside)
        pinAnnotationView.rightCalloutAccessoryView = rightButtonAccessory
        
        return annotationView
    }
    
    func accessHtmlLink(){
    
    }
    
    
}
