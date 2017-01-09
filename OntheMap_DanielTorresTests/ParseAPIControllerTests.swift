//
//  ParseApiTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/19/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres

class ParseApiTests: XCTestCase {
    
    func test_GetLocationsStudents_ListStudentLocation() {
        
        let parseApi = ParseApi()
        let expectation2 = expectation(description: "Swift Expectations")
        
        parseApi.getLastLocations(numberOfLocations: "100", completionHandlerForGettingLocations:{ (success, arrayStudentLocation, error) in
        
            if success {
                XCTAssert(true)
                expectation2.fulfill()
            }
        
        
        })
            
        waitForExpectations(timeout: 120.0, handler:nil)
    }
    
    func test_GetAStudentLocation_StudentLocation(){
        
        let api = ParseApi()
        let expectationSuccess = expectation(description: "Success Get Student Location Expectations")
        
        api.getStudentLocation(uniqueKeyAccount: "89298002948", completionHandlerForGettingLocation: { (studentLocation, error) in
            
            
            guard let studentLocation = studentLocation else {
                print(error!.description)
                XCTFail()
                return
            }
            
            XCTAssert(true)
            
            print(studentLocation.toString())
            expectationSuccess.fulfill()
            
        })
        
        
        waitForExpectations(timeout: 18.0, handler:nil)
        
    }
    
    
}
