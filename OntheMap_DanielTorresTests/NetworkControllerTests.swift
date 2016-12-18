//
//  NetworkControllerTests.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import XCTest
@testable import OntheMap_DanielTorres

class NetworkControllerTests: XCTestCase {
    
    func test_LoginWithUdacity_ResultFromParseData(){
    
        let networkController = NetworkController()
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(Credentials.username)\", \"password\": \"\(Credentials.password)\"}}".data(using: String.Encoding.utf8)
        
        let expectation2 = expectation(description: "Swift Expectations")
        
        let _ = networkController.taskForPOSTMethod(to: .udacity, request: request){ (result, errorString) in
        
            guard errorString == nil else {
                print(errorString!)
                return XCTFail("taskForPOSTMethod returns an error check request made")
            }
            
            guard result != nil else {
                return XCTFail("there data parsed returned from taskForPOSTMethod is nil check request made")
            }
            
            /* GUARD: Was there any data returned? */
            guard let dataParsed = result as? [String: AnyObject] else {
                return XCTFail("could not convert dataParse to dictionary")
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let session = dataParsed["session"] as? [String: AnyObject], let id = session["id"] as? String, id != "" else {
                
                return XCTFail("could not find keys")
            }
            expectation2.fulfill()
            XCTAssert(true)
            print("The data parsed \(dataParsed)")
        }
        
        waitForExpectations(timeout: 10.0, handler:nil)
        
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
