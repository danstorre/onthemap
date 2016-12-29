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
                
                for studentLocation in arrayStudentLocation! {
                    print(studentLocation.toString())
                }
            }else {
                print(errorMessage!)
            }
        })
        
        
        waitForExpectations(timeout: 5.0, handler:nil)
        
    }
    
    
    
    func test_PostAStudentLocation(){
    
        let api = ParseApiController()
        let locationController = LocationController()
        let expectationSuccess = expectation(description: "Success Post Student Locations Expectations")
        
        let studentLocationDict : [String:AnyObject] = [
                "\(ConstantsLocation.JSONBodyParseKeys.uniqueKey)" : "89298002948" as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.firstName)" : " Danny" as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.lastName)" : "Moe Wow" as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.mapString)" : "Mountain Cool, CA" as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.mediaURL)" : "https://classroom.udacity.com" as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.latitude)" :  84.386052 as AnyObject,
                "\(ConstantsLocation.JSONBodyResponseParseKeys.longitude)" : -122.083851 as AnyObject,
            ]
        
        let studentLocationToPost = StudentLocation(dictionary: studentLocationDict)
    
        locationController.postLocation(api, studentLocationToPost: studentLocationToPost, completionHandlerForPostingLocation: { (success, errorMessage) in
            
            if success {
                XCTAssert(true)
                expectationSuccess.fulfill()
            }else {
                print(errorMessage!)
            }
        })
        
        waitForExpectations(timeout: 180.0, handler:nil)
    
    }

    
    
}
