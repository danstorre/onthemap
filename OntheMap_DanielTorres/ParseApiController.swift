//
//  ParseApiController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class ParseApiController: ApiController, LocationsProtocol {

    
    func getLastLocations(numberOfLocations: Int, completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ error: NSError?) -> Void){
        
        
        
        /* 1. Set the parameters */
        let parameters : [String:AnyObject] = [
            ConstantsLocation.UrlKeys.limit : numberOfLocations as AnyObject
        ]
        
        /* 2. Build the URL & Configure the request*/
        var request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: Authentication.Methods.udacitySessionPath))
        
        request = createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.post, and: nil)
        
        /* 4. Make the request */
        networkController.taskForGetMethod(api: self, request: request, completionHandlerForGET: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGettingLocations(false, nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("taskForPOSTMethod returns an error")
            }
            
            if let session = result?[Authentication.JSONBodyResponseUdacityKeys.session] as? [String:AnyObject],
                let id = session[Authentication.JSONBodyResponseUdacityKeys.id] as? String{
                completionHandlerForGettingLocations(true, id, nil)
            } else {
                sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.session) in \(result)")
            }
            
        })

    
    }
}


// MARK:- Helper methods
private extension ParseApiController {
    // Create Request for udacity
    func createRequestForParseWith(request : NSMutableURLRequest, method: ConfigurationNetwork.HttpMethods, and jsonBody : Data?) -> NSMutableURLRequest{
        
        request.httpMethod = method.rawValue
        request.addValue(ConstantsLocation.ParseConstants.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ConstantsLocation.ParseConstants.applicationId, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        guard let jsonBody = jsonBody else {
            return request
        }
        
        request.httpBody = jsonBody
        
        return request
    }
    
    // create a URL from parameters
    
    func parseURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ConstantsLocation.ParseConstants.apiScheme
        components.host = ConstantsLocation.ParseConstants.apiHost
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

