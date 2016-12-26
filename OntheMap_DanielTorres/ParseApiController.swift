//
//  ParseApiController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class ParseApiController: ApiController, LocationsProtocol {
    
    
    // MARK:- Post Student Location
    func postStudentLocation(studentLocationToPost: StudentLocation, completionHandlerForPostingLocation: @escaping (Bool, NSError?) -> Void) {
        
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        
        guard let uniqueKey = appdelegate.networkState.uniqueKeyAccount else {
            return
        }
        
        let completionHandlerForGettingLocation = { (studentLocation: StudentLocation?, error: NSError?) -> () in
        
            guard studentLocation == nil else {
                //update student location
                let newAddress = Address(mapString: studentLocationToPost.pin!.address.mapString, location: studentLocationToPost.pin!.address.location)
                studentLocation!.pin!.mediaURL = studentLocationToPost.pin!.mediaURL
                studentLocation!.pin!.address = newAddress
                return self.putStudentLocation(studentLocationToPut: studentLocation!, completionHandlerForPuttingLocation: { (success, error) in
                    
                    if success {
                        completionHandlerForPostingLocation(true, nil)
                    }else {
                        completionHandlerForPostingLocation(false, error)
                    }
                    
                })
            }
            
            //add new student location
            
            /* 2. Build the URL & Configure the request*/
            var request = NSMutableURLRequest(url: self.parseURLFromParameters(nil, withPathExtension: ConstantsLocation.Methods.parseStudentsLocations))
            
            /* 3. Configure the request */
            let jsonBody = "{\"\(ConstantsLocation.JSONBodyResponseParseKeys.uniqueKey)\": \"\(uniqueKey)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.firstName)\": \"\(studentLocationToPost.pin!.user.firstName)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.lastName)\": \"\(studentLocationToPost.pin!.user.lastName)\",\"\(ConstantsLocation.JSONBodyResponseParseKeys.mapString)\": \"\(studentLocationToPost.pin!.address.mapString)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.mediaURL)\": \"\(studentLocationToPost.pin!.mediaURL)\",\"\(ConstantsLocation.JSONBodyResponseParseKeys.latitude)\": \(studentLocationToPost.pin!.address.location.coordinate.latitude), \"\(ConstantsLocation.JSONBodyResponseParseKeys.longitude)\": \(studentLocationToPost.pin!.address.location.coordinate.longitude)}".data(using: String.Encoding.utf8)
            
            request = self.createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.post, and: jsonBody)
            
            
            /* 4. Make the request */
            let _ = self.networkController.taskForPOSTMethod(api: self, request: request, completionHandlerForPOST: { (result, error) in
                
                
                func sendError(_ error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForPostingLocation(false, NSError(domain: "postStudentLocation", code: 4, userInfo: userInfo))
                }
                
                guard error == nil else {
                    return sendError("postStudentLocation returns an error")
                }
                
                guard let result = result?[ConstantsLocation.JSONBodyResponseParseKeys.objectId] as? String else {
                    return sendError("postStudentLocation returns an error")
                }
                
                print(result)

                completionHandlerForPostingLocation(true, nil)
            })

        }
        
        self.getStudentLocation(uniqueKeyAccount: uniqueKey, completionHandlerForGettingLocation: completionHandlerForGettingLocation)
    }
    
    // MARK:- Put New Student Location
    private func putStudentLocation(studentLocationToPut: StudentLocation, completionHandlerForPuttingLocation: @escaping (Bool, NSError?) -> Void) {
        
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        
        guard let uniqueKey = appdelegate.networkState.uniqueKeyAccount else {
            return
        }
        
        /* 2. Build the URL & Configure the request*/
        var request = NSMutableURLRequest(url: parseURLFromParameters(nil, withPathExtension: "\(ConstantsLocation.Methods.parseStudentsLocations)/\(studentLocationToPut.objectId)"))
        
        request = createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.put, and: nil)
        
        /* 3. Configure the request */
        let jsonBody = "{\"\(ConstantsLocation.JSONBodyResponseParseKeys.uniqueKey)\": \"\(studentLocationToPut.uniqueKey)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.firstName)\": \"\(studentLocationToPut.pin!.user.firstName)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.lastName)\": \"\(studentLocationToPut.pin!.user.lastName)\",\"\(ConstantsLocation.JSONBodyResponseParseKeys.mapString)\": \"\(studentLocationToPut.pin!.address.mapString)\", \"\(ConstantsLocation.JSONBodyResponseParseKeys.mediaURL)\": \"\(studentLocationToPut.pin!.mediaURL)\",\"\(ConstantsLocation.JSONBodyResponseParseKeys.latitude)\": \(studentLocationToPut.pin!.address.location.coordinate.latitude), \"\(ConstantsLocation.JSONBodyResponseParseKeys.longitude)\": \(studentLocationToPut.pin!.address.location.coordinate.longitude)}".data(using: String.Encoding.utf8)
        
        request = self.createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.put, and: jsonBody)
        
        /* 4. Make the request */
        networkController.taskForGetMethod(api: self, request: request, completionHandlerForGET: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPuttingLocation(false, NSError(domain: "putStudentLocation", code: 5, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("putStudentLocation returns an error")
            }
            
            guard let _ = result?[ConstantsLocation.JSONBodyResponseParseKeys.updatedAt] as? String else {
                return sendError("Could not find \(ConstantsLocation.JSONBodyResponseParseKeys.results) in \(result)")
            }

            completionHandlerForPuttingLocation(true, nil)
            
        })
    }
    
    
    // MARK:- Get Student Location
    
    private func getStudentLocation(uniqueKeyAccount: String, completionHandlerForGettingLocation: @escaping (StudentLocation?, NSError?) -> Void) {
        
        /* 1. Set the parameters */
        let jsonQuery = "{\"\(ConstantsLocation.JSONBodyParseKeys.uniqueKey)\": \(uniqueKeyAccount)}".data(using: String.Encoding.utf8)
        
        
        let parameters : [String:AnyObject] = [
            ConstantsLocation.UrlKeys.whereKey : jsonQuery as AnyObject
        ]
        
        /* 2. Build the URL & Configure the request*/
        var request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: ConstantsLocation.Methods.parseStudentsLocations))
        
        request = createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.get, and: nil)
        
        
        /* 4. Make the request */
        networkController.taskForGetMethod(api: self, request: request, completionHandlerForGET: { (result,error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGettingLocation(nil, NSError(domain: "getStudentLocation", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                return sendError("getStudentLocation returns an error")
            }
            
            guard let results = result?[ConstantsLocation.JSONBodyResponseParseKeys.results] as? [[String:AnyObject]], let studentLocationDict = results.first else {
                return sendError("Could not find \(ConstantsLocation.JSONBodyResponseParseKeys.results) in \(result)")
            }
            
            let studentLocation = StudentLocation(dictionary: studentLocationDict)
            
            completionHandlerForGettingLocation(studentLocation, nil)
            
        })
    
    }
    
    
    // MARK:- Get last Student Location

    func getLastLocations(numberOfLocations: String, completionHandlerForGettingLocations: @escaping (_ success: Bool, _ locations: [StudentLocation]?, _ error: NSError?) -> Void){
        
        /* 1. Set the parameters */
        let parameters : [String:AnyObject] = [
            ConstantsLocation.UrlKeys.limit : numberOfLocations as AnyObject,
            ConstantsLocation.UrlKeys.order : "\(ConstantsLocation.UrlKeys.descending)\(ConstantsLocation.JSONBodyParseKeys.updateAt)" as AnyObject
        ]
        
        /* 2. Build the URL & Configure the request*/
        var request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: ConstantsLocation.Methods.parseStudentsLocations))
        
        request = createRequestForParseWith(request: request, method: ConfigurationNetwork.HttpMethods.get, and: nil)
        
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
            
            guard let dictionaryOfStudentLocations = result?[ConstantsLocation.JSONBodyResponseParseKeys.results] as? [[String:AnyObject]] else {
                return sendError("Could not find \(ConstantsLocation.JSONBodyResponseParseKeys.results) in \(result)")
            }
            
            let arrayOfStudentLocation = StudentLocation.arrayOfStudentLocations(from: dictionaryOfStudentLocations)
            
            completionHandlerForGettingLocations(true, arrayOfStudentLocation, nil)
            
        })

    
    }
}


// MARK:- Helper methods
private extension ParseApiController {
    // Create Request for PARSE
    func createRequestForParseWith(request : NSMutableURLRequest, method: ConfigurationNetwork.HttpMethods, and jsonBody : Data?) -> NSMutableURLRequest{
        
        request.httpMethod = method.rawValue
        request.addValue(ConstantsLocation.ParseConstants.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ConstantsLocation.ParseConstants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        guard let jsonBody = jsonBody else {
            return request
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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

