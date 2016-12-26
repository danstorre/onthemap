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
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        addGestures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Buttons
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        hideKeyBoard()
        let api = UdacityApiController()
        let authentication = AuthenticationController()
        activity.startAnimating()
        loginButton.isUserInteractionEnabled = false
        
        authentication.authenticateWith(api, userName: emailTextField.text!, password: passTextField.text!){ (success, errorString) in
            
            performUIUpdatesOnMain{
                
                guard success else {
                    return self.displayAlert(errorString!) {
                        self.activity.stopAnimating()
                        self.loginButton.isUserInteractionEnabled = true
                    }
                }
                
                self.goToNextViewController()
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
