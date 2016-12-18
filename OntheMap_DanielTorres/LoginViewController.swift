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
        
        authentication.authenticateWith(api, userName: "", password: ""){ (success, errorString) in
            
            if success {
                print("paso")
            }else {
                print(errorString!)
            }
            
        }
    }
    
    // MARK: Login
    
    private func goToNextViewController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }

}

// MARK: - LoginViewController (Configure UI)

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
