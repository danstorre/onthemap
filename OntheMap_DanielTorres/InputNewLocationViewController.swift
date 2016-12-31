//
//  InputNewLocationViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/29/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class InputNewLocationViewController: UIViewController {

    @IBOutlet weak var inputLocation: TextFieldLogin!
    @IBOutlet weak var inputMediaUrl: TextFieldLogin!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperViewTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let customTFDelegate : TextFieldDelegateOnTheMap = TextFieldDelegateOnTheMap()
    
    var nextViewIsDisplated = false
    
    var newMKannotation : MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        addGestures()
        upperViewTitle.attributedText = configureTitle(string: upperViewTitle.text!)
        upperViewTitle.textAlignment = .center
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        
        guard !nextViewIsDisplated else {
            
           finishPosting()
           return
        }
        
        guard let addressToSearch = inputLocation.text, addressToSearch != "" else {
            self.displayAlert("You have to input an address", completionHandler: {})
            return
        }
        
        let locationController = LocationController()
        
        locationController.getLocation(from: addressToSearch, inMap: mapview,   completionHandlerForGetAddress: { (success, placeMark, errorMessage) in
            
            performUIUpdatesOnMain {
                guard success else {
                    self.displayAlert(errorMessage!, completionHandler: {})
                    return
                }
                self.newMKannotation = placeMark
                
            }
        })
        self.nextView()
    }
    

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -Navigation flow
    
    func nextView(){
        nextViewIsDisplated = true
        UIView.animate(withDuration: 0.6, animations: {
            
            self.view.backgroundColor = Color.OntheMapColors.backgroundDarkBlue
            self.upperView.backgroundColor = Color.OntheMapColors.backgroundDarkBlue
            self.upperViewTitle.isHidden = true
            self.inputLocation.isHidden = true
            self.inputMediaUrl.isHidden = false
            self.lowerView.backgroundColor = UIColor(white: 1, alpha: 0.3)
            self.mapview.isHidden = false
        })
        
        self.button.setTitle("Submit", for: UIControlState.normal)
        self.cancelButton.titleLabel?.textColor = UIColor.white
    }

    func finishPosting(){
        
        guard let mediaurl = inputMediaUrl.text, mediaurl != "" else {
            return self.displayAlert("Don't you want to share a media url?", completionHandler: {})
        }
        
        guard let newMKannotation = newMKannotation else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        
        activity.startAnimating()
        button.isEnabled = false
        
        let locationController = LocationController()
        let parseAPI = ParseApiController()
        
        //verify if the user has a student location in parse (automatic saved in appDelegate )
        let firsName = appDelegate.locationController.currentUserStudentLocation.pin?.user.lastName
        let lastName = appDelegate.locationController.currentUserStudentLocation.pin?.user.firstName
        let uniqueKey = appDelegate.locationController.currentUserStudentLocation.uniqueKey
        //Post student location
        let newLocation = LocationAnnotation(coordinate: newMKannotation.coordinate)
        let newAddress = Address(mapString: inputLocation.text!, location: newLocation)
        let pin = Pin(mediaURL: mediaurl, user: User(firstName: firsName!, lastName: lastName!), address: newAddress)
        let studentLocationToPost = StudentLocation(objectId: "", uniquekey: uniqueKey!, pin: pin)
        
        locationController.postLocation(parseAPI, studentLocationToPost: studentLocationToPost, completionHandlerForPostingLocation: { (success, errorMessageFromPost) in
            performUIUpdatesOnMain {
                guard errorMessageFromPost == nil else {
                    let mapViewController : UIViewController? = UIApplication.shared.windows.first?.rootViewController
                    
                    return mapViewController!.displayAlert(errorMessageFromPost!, completionHandler: {})
                }
            }
        })
        
        self.activity.stopAnimating()
        self.dismiss(animated: true, completion: {})
    }

}


// MARK: - InputNewLocationViewController (Configure UI, HelperMethods)

private extension InputNewLocationViewController {
    
    func configureTextFields(){
        inputLocation.placeholderLogin = "Enter your location here"
        inputMediaUrl.placeholderLogin = "Enter a link to share"
        inputLocation.delegate = customTFDelegate
        inputMediaUrl.delegate = customTFDelegate
    }
    
    func configureTitle(string: String) -> NSMutableAttributedString{
        let copiedString = string as NSString
        let attributedString = NSMutableAttributedString(string: copiedString as String)
        
        let defaultTextAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: Color.OntheMapColors.backgroundDarkBlue ,
            NSFontAttributeName: Font.OntheMapFontFamily.robotoThin!.withSize(24)
        ]
        
        let attributedStringRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(defaultTextAttributes, range: attributedStringRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSParagraphStyleAttributeName,value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let highLightTextAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: Color.OntheMapColors.backgroundDarkBlue ,
            NSFontAttributeName: Font.OntheMapFontFamily.robotoMedium!.withSize(24)
        ]
        
        var highlightRange : NSRange
        
        highlightRange = copiedString.range(of: "Studying", options: NSString.CompareOptions.caseInsensitive)
        
        // found one
        if highlightRange.location != NSNotFound {
            attributedString.addAttributes(highLightTextAttributes, range: highlightRange)
        }
        
        return attributedString
    }
    
    // MARK:- Gesture Methods
    
    func addGestures() {
        
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer()
        gestureTap.addTarget(self, action: #selector(hideKeyBoard))
        self.view.addGestureRecognizer(gestureTap)
    }
    
    
    // MARK:- Helper Methods
    
    @objc func hideKeyBoard(){
        guard let textFieldFirsResponder = self.currentFirstResponder() else {
            return
        }
        
        guard textFieldFirsResponder.self is UITextField else {
            return
        }
        let _ = textFieldFirsResponder.resignFirstResponder()
    }
    
    
    
    
}

