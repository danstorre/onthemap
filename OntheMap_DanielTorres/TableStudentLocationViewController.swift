//
//  TableStudentLocationViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/31/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class TableStudentLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableStudentLocations: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(TableStudentLocationViewController.didReloadData), name: Notification.notificationRefreshData, object: nil)
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.notificationRefreshData, object: nil)
    }

    // MARK: - notifications
    
    func didReloadData(){
        reloadData()
    }
    
    func reloadData(){
        
        
        
        
        tableStudentLocations.reloadData()
    }
    
    
    // MARK: - tableview methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.shared.lastLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOfStudentLocation = tableView.dequeueReusableCell(withIdentifier: "studentcell")! as UITableViewCell
        
        let studentLocation = StudentInformation.shared.lastLocations[indexPath.row]
        
        
        guard let pin = studentLocation.pin, pin.user.lastName != "" else {
            
            return UITableViewCell()
        }
        
        cellOfStudentLocation.textLabel?.text = pin.user.firstName + " " + pin.user.lastName
        
        cellOfStudentLocation.imageView?.image = #imageLiteral(resourceName: "pin")

        return cellOfStudentLocation
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentInformation.shared.lastLocations[indexPath.row]
        
        guard let link = studentLocation.pin?.mediaURL , let url = URL(string: link), (link.contains("http://") || link.contains("https://")) else {
            
            
            return self.displayAlert("Sorry there is no media link provided by this user", completionHandler: {})
        }
        
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let studentLocation = StudentInformation.shared.lastLocations[indexPath.row]
        
        guard let pin = studentLocation.pin, pin.user.lastName != "" else {
            return 0
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    

}
