//
//  AthenticationController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/15/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class AuthenticationController {
    
    // MARK:- Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- Methods for authentication
    func authenticateWith(_ api: AuthenticationProtocol, userName: String, password: String,  completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let completionForSessionID = { (success: Bool, sessionID: String?, errorString: String?) -> Void in
            if success {
                //If success set sessionId to the shared networkController object
                self.appDelegate.networkState.sessionID = sessionID
                completionHandlerForLogin(true, nil)
            }
            else {
                completionHandlerForLogin(false, errorString)
            }
        }

        api.getSessionID(userName, password: password, completionHandlerForLogin: completionForSessionID)
    
    }
    
    
    
}

