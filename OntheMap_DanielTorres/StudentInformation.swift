//
//  StudentInformation.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 1/8/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit

final class StudentInformation : NSObject {

    var currentStudentLocation = StudentLocation()
    var lastLocations: [StudentLocation] = [StudentLocation]()
    
    static let shared = StudentInformation()

}
