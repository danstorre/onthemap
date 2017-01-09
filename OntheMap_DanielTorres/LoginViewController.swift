//
//  LoginViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/14/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - properties
    @IBOutlet weak var emailTextField: TextFieldLogin!
    @IBOutlet weak var passTextField: TextFieldLogin!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    let customTFDelegate : TextFieldDelegateOnTheMap = TextFieldDelegateOnTheMap()
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    @IBOutlet weak var signUpButton: UIButton!
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        addGestures()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkReachability()
        passTextField.text = ""
        loginButton.isEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    // MARK:- Reachabilty Methods

    func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }

    func checkReachability() {
        guard let r = reachability else { return }
        guard r.isReachable else {
            performUIUpdatesOnMain {
                let rootViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController
                
                
                guard let presentedViewController = rootViewController?.presentedViewController else {
                    return rootViewController!.displayAlert("Check Your Internet Connection", completionHandler: {})
                }
                
                presentedViewController.displayAlert("Check Your Internet Connection", completionHandler: {})
                
                
            }
            return
        }
    }
    
    // MARK:- Buttons
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let link = "https://auth.udacity.com/"
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        hideKeyBoard()
        let api = UdacityApi()
        let parseAPI = ParseApi()
        let authentication = AuthenticationAPI()
        let locationController = Location()
        
        activity.startAnimating()
        loginButton.isEnabled = false
        
        authentication.authenticateWith(api, userName: emailTextField.text!, password: passTextField.text!){ (success, errorString) in
            
            performUIUpdatesOnMain{
                self.loginButton.isEnabled = true
                guard success else {
                    let reachabilityDidChangeNotification = Notification.Name("ReachabilityDidChangeNotification")
                    NotificationCenter.default.post(name: reachabilityDidChangeNotification, object: nil)
                    return self.displayAlert(errorString!) {
                        self.activity.stopAnimating()
                        self.loginButton.isUserInteractionEnabled = true
                    }
                }
                
                self.goToNextViewController()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                locationController.getStudentLocation(parseAPI, uniqueKeyAccount: appDelegate.networkState.uniqueKeyAccount!, completionHandlerForGettingLocation: { (userStudentLocation, errorString) in
                    guard errorString == nil else {
                        return
                    }
                    
                    StudentInformation.shared.currentStudentLocation = userStudentLocation!
                })
                
            }
        }
    }
    
    // MARK: Navigation
    
    private func goToNextViewController() {
        self.loginButton.isUserInteractionEnabled = true
        self.activity.stopAnimating()
        let storyboard =  UIStoryboard(name: "MainNavigationOntheMap", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController?.show(vc, sender: nil)
        
    }

}

// MARK: - LoginViewController (Configure UI, HelperMethods)

private extension LoginViewController {

    func configureTextFields(){
        emailTextField.placeholderLogin = "Email"
        passTextField.placeholderLogin = "Password"
        emailTextField.delegate = customTFDelegate
        passTextField.delegate = customTFDelegate
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
        
        let _ = textFieldFirsResponder.resignFirstResponder()
    }
    
    
    

}
