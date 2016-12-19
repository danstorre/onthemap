//
//  UdacityAPIControllerTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres


class UdacityAPIControllerTests: XCTestCase {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func test_GetSessionID_SessionID() {
        
        let udacityApi = UdacityApiController()
        let expectation2 = expectation(description: "Swift Expectations")
        
        udacityApi.getSessionID("\(Credentials.username)", password: "\(Credentials.password)") { (success, sessionID, error) in
            
            if success {
                print("the session ID is \(sessionID!)")
                XCTAssert(true)
                expectation2.fulfill()
            } else {
                XCTFail("no session ID returned")
            }
        }
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    
}
