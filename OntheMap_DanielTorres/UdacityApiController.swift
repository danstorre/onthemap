//
//  UdacityApiController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class UdacityApiController: AuthenticationProtocol {

    
    let networkController = NetworkController()
    
    // MARK:- methods for authentication
    
    func getSessionID(_ userName: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void)
    {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        var request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: Authentication.Methods.udacitySessionPath))
        
        /* 3. Configure the request */
        let jsonBody = "{\"\(Authentication.JSONBodyUdacityKeys.udacity)\": {\"\(Authentication.JSONBodyUdacityKeys.username)\": \"\(userName)\", \"\(Authentication.JSONBodyUdacityKeys.password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        request = createRequestForUdacityWith(request: request, and: jsonBody!)
        
        /* 4. Make the request */
        let _ = networkController.taskForPOSTMethod(to: .udacity, request: request, completionHandlerForPOST: { (result,error) in
            
            guard error == nil else {
                print(error!)
                return completionHandlerForLogin(false, nil, "Login Failed (Request Session).")
            }
            
            if let session = result?[Authentication.JSONBodyResponseUdacityKeys.session] as? [String:AnyObject],
                let id = session[Authentication.JSONBodyResponseUdacityKeys.id] as? String{
                completionHandlerForLogin(true, id, nil)
            } else {
                print("Could not find \(Authentication.JSONBodyResponseUdacityKeys.session) in \(result)")
                completionHandlerForLogin(false, nil, "Login Failed (Request Session).")
            }
            
        })
    }
    
    // MARK:- Helper methods
    
    // Create Request for udacity 
    private func createRequestForUdacityWith(request : NSMutableURLRequest,and jsonBody : Data) -> NSMutableURLRequest{
        
        request.httpMethod = ConfigurationNetwork.HttpMethods.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        return request
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Authentication.UdacityConstants.ApiScheme
        components.host = Authentication.UdacityConstants.ApiHost
        components.path = withPathExtension ?? ""
        
        guard let parameters = parameters else {
            return components.url!
        }
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
}
