//
//  InputNewLocationViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/29/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

class InputNewLocationViewController: UIViewController {

    @IBOutlet weak var inputLocation: TextFieldLogin!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputLocation.placeholderLogin = "Enter your location here"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }



}
