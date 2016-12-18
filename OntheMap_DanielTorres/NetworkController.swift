//
//  NetworkController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/15/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    
    // MARK: POST
    
    func taskForPOSTMethod(to api: Authentication.API, request: NSMutableURLRequest,
                           completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if api == .udacity {
                let range = Range(uncheckedBounds: (5, data.count))
                data = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
}


private extension NetworkController {
    
    // MARK:- Helpers 
    
    // given raw JSON, return a usable Foundation object
     func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    

}
