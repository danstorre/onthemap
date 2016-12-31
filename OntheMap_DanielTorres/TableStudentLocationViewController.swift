//
//  TableStudentLocationViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/31/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class TableStudentLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listStudentLocations = [StudentLocation]()

    @IBOutlet weak var tableStudentLocations: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(TableStudentLocationViewController.didReloadData), name: Notification.notificationRefreshData, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.notificationRefreshData, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - notifications
    
    func didReloadData(){
        
        reloadData()
    }
    
    func reloadData(){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        listStudentLocations = appDelegate.locationController.lastLocations
        
        listStudentLocations.sort { (student1, student2) -> Bool in
            
            guard student1.pin != nil, student2.pin != nil else {
                return false
            }
            return student1.pin!.user.lastName < student1.pin!.user.lastName
        }
        tableStudentLocations.reloadData()
    }
    
    
    // MARK: - tableview methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStudentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOfStudentLocation = tableView.dequeueReusableCell(withIdentifier: "studentcell")! as UITableViewCell
        
        let studentLocation = listStudentLocations[indexPath.row]
        
        
        guard let pin = studentLocation.pin, pin.user.lastName != "" else {
            
            return UITableViewCell()
        }
        
        cellOfStudentLocation.textLabel?.text = pin.user.firstName + " " + pin.user.lastName
        
        cellOfStudentLocation.imageView?.image = #imageLiteral(resourceName: "pin")

        return cellOfStudentLocation
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = listStudentLocations[indexPath.row]
        
        guard let link = studentLocation.pin?.mediaURL , let url = URL(string: link), (link.contains("http://") || link.contains("https://")) else {
            
            
            return self.displayAlert("Sorry there is no media link provided by this user", completionHandler: {})
        }
        
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let studentLocation = listStudentLocations[indexPath.row]
        
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
    

}
