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
    let customTFDelegate : OnTheMapTextFieldDelegate = OnTheMapTextFieldDelegate()
    
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
        let api = UdacityApiController()
        let authentication = AuthenticationController()
        self.activity.startAnimating()
        
        authentication.authenticateWith(api, userName: emailTextField.text!, password: passTextField.text!){ (success, errorString) in
            
            performUIUpdatesOnMain{
                if success {
                    self.activity.stopAnimating()
                    self.goToNextViewController()
                }else {
                    
                    self.displayAlert(errorString!)
                }
            }
        }
    }
    
    // MARK: Login
    
    private func goToNextViewController() {
        performSegue(withIdentifier: "login", sender: nil)
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
    
    func displayAlert(_ errorString: String) {
        
        let alertViewController = UIAlertController(title: "Login", message: errorString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okButton)
        self.present(alertViewController, animated: true, completion: {
                self.activity.stopAnimating()
            }
        )
        
    }
    

}
