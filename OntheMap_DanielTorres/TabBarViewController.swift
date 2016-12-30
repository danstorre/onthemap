//
//  TabBarViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController {

    
    @IBOutlet weak var pin: UIBarButtonItem!
    @IBOutlet weak var refreshData: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func logOutButtonAction(_ sender: UIBarButtonItem) {
        
        let api = UdacityApiController()
        let authentication = AuthenticationController()
        userinteractionOnBarButtonItems(false)
        
        authentication.logOutWith(api, completionHandlerForLogOut: {(success, idSession, errorString) in
            
            performUIUpdatesOnMain {
                guard success else {
                    self.userinteractionOnBarButtonItems(true)
                    return self.displayAlert(errorString!, completionHandler: {})
                }
                self.goBackToLogin()
            }
        }
        )
    }
    
    // MARK: - Navigation
    private func goBackToLogin(){
        self.navigationController?.dismiss(animated: true, completion: {
            performUIUpdatesOnMain {
                
                let loginViewController : UIViewController? = UIApplication.shared.windows.first?.rootViewController
                
                UIView.animate(withDuration: 0.6, animations: {
                    loginViewController?.displayMessage("Come back any time!", "Logout Success", completionHandler: {})
                })
                
            }
        })
    }
    
    @IBAction func goToInputScreen(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard appDelegate.locationController.currentUserStudentLocation.objectId == "" else {
            let alertViewController = UIAlertController(title: "Alert!", message: "You have already posted a Student Location. would you like to override  your current Location?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler:{ (alerAction) in
                self.performSegue(withIdentifier: "showInputScreen", sender: nil)
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertViewController.addAction(okButton)
            alertViewController.addAction(cancelButton)
            
            self.present(alertViewController, animated: true, completion: nil)
        
            return
        }
        
        performSegue(withIdentifier: "showInputScreen", sender: nil)
    }
    

    @IBAction func refreshData(_ sender: Any) {
        let notificationRefreshData = Notification.Name("refreshData")
        NotificationCenter.default.post(name: notificationRefreshData, object: nil)
    }
    
}

// MARK: - helper methods

private extension TabBarViewController {

    func userinteractionOnBarButtonItems(_ on: Bool){
        self.pin.isEnabled = on
        self.refreshData.isEnabled = on
        self.logout.isEnabled = on
        
    }
}


