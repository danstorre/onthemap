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

    
    // MARK: - Actions
    
    @IBAction func logOutButtonAction(_ sender: UIBarButtonItem) {
        
        let api = UdacityApi()
        let authentication = AuthenticationAPI()
        userinteractionOnBarButtonItems(false)
        
        authentication.logOutWith(api, completionHandlerForLogOut: {(success, idSession, errorString) in
            
            performUIUpdatesOnMain {
                let loginViewController : UIViewController? = UIApplication.shared.windows.first?.rootViewController
                guard success else {
                    self.userinteractionOnBarButtonItems(true)
                    return loginViewController!.displayAlert(errorString!, completionHandler: {})
                }
                
                UIView.animate(withDuration: 0.6, animations: {
                    loginViewController?.displayMessage("Come back any time!", "Logout Success", completionHandler: {})
                })
            }
        })
        
        self.navigationController?.dismiss(animated: true, completion: {})
    }
    
    // MARK: - Navigation
    
    @IBAction func goToInputScreen(_ sender: Any) {
        
        guard StudentInformation.shared.currentStudentLocation.objectId == "" else {
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


