//
//  LocationsControllerTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/19/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres

class LocationsControllerTests: XCTestCase {

    func test_GetListOfStudentsLocations_ArrayStudentLocation() {
        
        let api = ParseApiController()
        let locationController = LocationController()
        let expectationSuccess = expectation(description: "Success List Student Locations Expectations")
        
        
        locationController.getLocations(api, numberOFlocationsAsked: 100, completionHandlerForGettingLocations: { (success, arrayStudentLocation, errorMessage) in
            
            if success {
                XCTAssert(true)
                expectationSuccess.fulfill()
                print(arrayStudentLocation!)
            }else {
                print(errorMessage!)
            }
        })
        
        
        waitForExpectations(timeout: 5.0, handler:nil)
        
    }

    
    
}
