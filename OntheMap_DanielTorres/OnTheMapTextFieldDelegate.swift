//
//  OnTheMapTextFieldDelegate.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/14/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class OnTheMapTextFieldDelegate: NSObject, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}
