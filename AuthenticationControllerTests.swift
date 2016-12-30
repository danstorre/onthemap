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
        let expectationSuccess = expectation(description: "Success Login Expectations")
        let expectationWrongCredentials = expectation(description: "Failure Login credentials")
        
        
        authenticationController.authenticateWith(api, userName: Credentials.username, password: Credentials.password, completionHandlerForLogin: { (success, errorString) in
            
            if success {
                XCTAssert(true)
                expectationSuccess.fulfill()
            }else {
                print(errorString!)
            }
        })
        
        authenticationController.authenticateWith(api, userName: "", password: "", completionHandlerForLogin: { (success, errorString) in
            
            if !success {
                XCTAssert(true)
                expectationWrongCredentials.fulfill()
                print(errorString!)
            }
        })
        
        waitForExpectations(timeout: 15.0, handler:nil)
        
    }
    
    func test_LogoutWithUdacity() {
        
        let api = UdacityApiController()
        let authenticationController = AuthenticationController()
        let expectations = expectation(description: "Logout with udacity Expectations")
        
        
        authenticationController.logOutWith(api, completionHandlerForLogOut: { (success, idSession, errorString) in
            
            if success {
                print("id session deleted \(idSession!)")
                XCTAssert(self.appDelegate.networkState.sessionID == "")
                expectations.fulfill()
            }else {
                print(errorString!)
            }
        })
        
        waitForExpectations(timeout: 10.0, handler:nil)
        
    }
    
    
}
