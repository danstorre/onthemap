//
//  LocationsProtocol.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

protocol LocationsProtocol {
    
    func getLastLocations(numberOfLocations: Int,completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ error: NSError?) -> Void)

}
