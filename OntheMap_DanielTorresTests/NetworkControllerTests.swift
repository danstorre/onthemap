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
    
    func test_TaskForPost_ResultFromParseData(){
    
        let networkController = NetworkController()
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\", \"password\": \"\"}}".data(using: String.Encoding.utf8)
        
        let expectation2 = expectation(description: "Swift Expectations")
        
        let _ = networkController.taskForPOSTMethod(to: .udacity, request: request){ (result, errorString) in
        
            guard errorString == nil else {
                print(errorString!)
                return XCTAssert(false)
            }
            
            guard result != nil else {
                return XCTAssert(false)
            }
            
            XCTAssert(true)
            
            expectation2.fulfill()
            
        }
        
        waitForExpectations(timeout: 10.0, handler:nil)
        
    }
    
    func test_ParseAData_DataParse(){
        
        let expectation2 = expectation(description: "Swift Expectations")
        let networkController = NetworkController()
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"danstorre@gmail.com\", \"password\": \"cloudingBot$90\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
//            networkController.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: { (dataParsed,error) in
//            
//                guard error == nil else {
//                    return print("the error code: \(error!.code)")
//                }
//                
//                if let dataParsed = dataParsed {
//                    //print(NSString(data: dataParsed as! Data, encoding: String.Encoding.utf8.rawValue)!)
//                    expectation2.fulfill()
//                }
//            })
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            expectation2.fulfill()
            
        }
        task.resume()
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
