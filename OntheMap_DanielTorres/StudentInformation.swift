//
//  StudentInformation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 1/8/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit

class StudentInformation : NSObject {

    var currentStudentLocation = StudentLocation()
    var lastLocations: [StudentLocation] = [StudentLocation]()
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }

}
