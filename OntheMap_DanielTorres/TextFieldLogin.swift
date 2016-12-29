//
//  textFieldLogin.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/14/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class TextFieldLogin: UITextField {

    
    
    var placeholderLogin : String = "" {
        
        didSet{
            
            let newAttributedString = NSMutableAttributedString(string: placeholderLogin)
            
            let loginPlaceHolderAttributes: [String : AnyObject] = [
                NSForegroundColorAttributeName:  UIColor.white,
                NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 17)!
            ]
            
            let attributedStringToSetRange = NSRange(location: 0, length: newAttributedString.length)
            newAttributedString.addAttributes(loginPlaceHolderAttributes, range: attributedStringToSetRange)
            
            attributedPlaceholder = newAttributedString
        }
    
    }
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    

}
