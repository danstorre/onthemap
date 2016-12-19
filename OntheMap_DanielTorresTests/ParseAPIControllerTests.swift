//
//  ParseAPIControllerTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/19/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres

class ParseAPIControllerTests: XCTestCase {
    
    func test_GetLocationsStudents_ListStudentLocation() {
        
        let parseApi = ParseApiController()
        let expectation2 = expectation(description: "Swift Expectations")
        
        parseApi.getLastLocations(numberOfLocations: "100", completionHandlerForGettingLocations:{ (success, arrayStudentLocation, error) in
        
            if success {
                XCTAssert(true)
                expectation2.fulfill()
            }
        
        
        })
            
        waitForExpectations(timeout: 120.0, handler:nil)
    }
    
}
