//
//  AuthenticationProtocol.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/17/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

protocol AuthenticationProtocol {
    func getSessionID(_ userName: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void)
    func deleteSession(completionHandlerForLogout: @escaping (_ success: Bool, _ deletedSessionID: String?, _ error: NSError?) -> Void)
}
