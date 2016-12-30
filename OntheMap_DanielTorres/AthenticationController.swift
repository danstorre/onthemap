//
//  AthenticationController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/15/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class AuthenticationController: NSObject {
    
    // MARK:- Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- Methods for authentication
    func authenticateWith(_ api: AuthenticationProtocol, userName: String, password: String,  completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let completionForSessionID = { (success: Bool, sessionID: String?, keyAccount: String?, error: NSError?) -> Void in
            
            if success {
                //If success set sessionId to the shared networkController object
                self.appDelegate.networkState.sessionID = sessionID
                self.appDelegate.networkState.uniqueKeyAccount = keyAccount
                api.getUserData(keyAccount!, completionForGettingUserData: { (firstName, lastName, error) in
                    
                    guard error == nil else {
                        print(error!)
                        return completionHandlerForLogin(false, "Athentication failed please try again")
                    }
                    
                    
                    guard let pin = self.appDelegate.locationController.currentUserStudentLocation.pin else {
                        return
                    }
                    pin.user.firstName = firstName!
                    pin.user.lastName = lastName!
                    self.appDelegate.locationController.currentUserStudentLocation.uniqueKey = keyAccount
                    
                })
                
                completionHandlerForLogin(true, nil)
                
            }
            else {
                print(error!)
                completionHandlerForLogin(false, "Athentication failed please try again")
            }
        }

        api.getSessionID(userName, password: password, completionHandlerForLogin: completionForSessionID)
    }
    
    func logOutWith(_ api: AuthenticationProtocol, completionHandlerForLogOut: @escaping (_ success: Bool, _ deletedSessionID: String?, _ errorString: String?) -> Void){
        
        let completionForLogout = { (success: Bool, deletedSessionID: String?, error: NSError?) -> Void in
            
            if success {
                self.appDelegate.networkState.sessionID = ""
                completionHandlerForLogOut(true, deletedSessionID, nil)
            }
            else {
                print(error!)
                completionHandlerForLogOut(false, deletedSessionID, "Logout failed please try again")
            }
        }
        
        api.deleteSession(completionHandlerForLogout: completionForLogout)
    }

    
    
    
}

