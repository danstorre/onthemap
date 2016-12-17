//
//  ViewExtension.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/14/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit


var currentFirstResponderObject : AnyObject? = nil

extension UIResponder {
    
    func currentFirstResponder() -> AnyObject? {
        currentFirstResponderObject = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder), to: nil, from: nil, for: nil)
        return currentFirstResponderObject
    }
    
    func findFirstResponder(sender: AnyObject) {
        currentFirstResponderObject = self
    }
    

}
