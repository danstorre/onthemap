//
//  UdacityApiController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class UdacityApiController: ApiController, AuthenticationProtocol {

    
    
    
    // MARK:- methods for authentication
    
    func deleteSession(completionHandlerForLogout: @escaping (_ success: Bool, _ deletedSessionID: String?, _ error: NSError?) -> Void)
    {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: Authentication.Methods.udacitySessionPath))
        
        /* 3. Configure the request */
        request.httpMethod = ConfigurationNetwork.HttpMethods.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let _ = networkController.taskForDeleteMethod(from: self, request: request, completionHandlerForDelete: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogout(false, nil, NSError(domain: "deleteSession", code: 2, userInfo: userInfo))
            }
            
            guard error == nil else {
                print(error!)
                return sendError("taskForPOSTMethod returns an error")
            }
            
            guard let session = result?[Authentication.JSONBodyResponseUdacityKeys.session] as? [String:AnyObject],
                let id = session[Authentication.JSONBodyResponseUdacityKeys.id] as? String else {
                return sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.session) in \(result)")
            }
            
            completionHandlerForLogout(true, id, nil)
            
        })
    }
    
    func getSessionID(_ userName: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ sessionID: String?, _ keyAccount: String?, _ error: NSError?) -> Void)
    {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        var request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: Authentication.Methods.udacitySessionPath))
        
        /* 3. Configure the request */
        let jsonBody = "{\"\(Authentication.JSONBodyUdacityKeys.udacity)\": {\"\(Authentication.JSONBodyUdacityKeys.username)\": \"\(userName)\", \"\(Authentication.JSONBodyUdacityKeys.password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        request = createRequestForUdacityWith(request: request, method: ConfigurationNetwork.HttpMethods.post, and: jsonBody!)
        
        /* 4. Make the request */
        let _ = networkController.taskForPOSTMethod(api: self, request: request, completionHandlerForPOST: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogin(false, nil, nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("taskForPOSTMethod returns an error")
            }
            
            guard let session = result?[Authentication.JSONBodyResponseUdacityKeys.session] as? [String:AnyObject],
            let id = session[Authentication.JSONBodyResponseUdacityKeys.id] as? String else {
                return sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.session) in \(result)")
            }
            
            guard let account = result?[Authentication.JSONBodyResponseUdacityKeys.account] as? [String:AnyObject],
                let key = account[Authentication.JSONBodyResponseUdacityKeys.key] as? String else {
                    return sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.account) in \(result)")
            }
            
            completionHandlerForLogin(true, id, key, nil)
            
        })
    }
    
    
    func getUserData(_ uniqueKeyAccount: String, completionForGettingUserData: @escaping (_ firstName: String?, _ lastName:String?,_ error: NSError?)->Void ){
    
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        var request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: "\(Authentication.Methods.udacityDataUserPath)/\(uniqueKeyAccount)"))
        request = createRequestForUdacityWith(request: request, method: ConfigurationNetwork.HttpMethods.get, and: nil)
        
        /* 4. Make the request */
        networkController.taskForGetMethod(api: self, request: request, completionHandlerForGET: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionForGettingUserData(nil,nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("taskForPOSTMethod returns an error")
            }
            
            guard let user = result?[Authentication.JSONBodyResponseUdacityKeys.user] as? [String:AnyObject], let firstName = user[Authentication.JSONBodyResponseUdacityKeys.firstName] as? String else {
                return sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.user) in \(result)")
            }
            
            guard let lastName = user[Authentication.JSONBodyResponseUdacityKeys.lastName] as? String else {
                return sendError("Could not find \(Authentication.JSONBodyResponseUdacityKeys.lastName) in \(result)")
            }
            
            completionForGettingUserData(firstName, lastName, nil)
            
        })
    
    }
}


// MARK:- Helper methods
private extension UdacityApiController {
    // Create Request for udacity 
    func createRequestForUdacityWith(request : NSMutableURLRequest, method: ConfigurationNetwork.HttpMethods, and jsonBody : Data?) -> NSMutableURLRequest{
        
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let jsonBody = jsonBody else {
            return request
        }
        
        request.httpBody = jsonBody
        
        return request
    }
    
    // create a URL from parameters
    
    func udacityURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
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
