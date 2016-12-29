//
//  LocationsProtocol.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

protocol LocationsProtocol {
    
    func getLastLocations(numberOfLocations: String,completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ error: NSError?) -> Void)
    func postStudentLocation(studentLocationToPost: StudentLocation, completionHandlerForPostingLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void)
    func getStudentLocation(uniqueKeyAccount: String, completionHandlerForGettingLocation: @escaping (StudentLocation?, NSError?) -> Void) 
    
    

}
