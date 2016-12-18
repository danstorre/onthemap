//
//  AuthenticationControllerTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres

class AuthenticationControllerTests: XCTestCase {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func test_AuthenticateWithUdacity_SessionID() {
        
        let api = UdacityApiController()
        let authenticationController = AuthenticationController()
        let expectation2 = expectation(description: "Swift Expectations")
        
        
        authenticationController.authenticateWith(api, userName: Credentials.username, password: Credentials.password, completionHandlerForLogin: { (success, errorString) in
            
            if success {
                XCTAssert(true)
                expectation2.fulfill()
            }else {
                print(errorString!)
            }
        })
        
        waitForExpectations(timeout: 5.0, handler:nil)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
