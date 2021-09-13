//
//  ProfileVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileVC: UIViewController {
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var emailAddressLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = User.decodeUserDefaults() else {
            return
        }
        self.currentUser = user
        self.fullNameLabel.text = self.currentUser.firstName + " " + self.currentUser.lastName
        self.emailAddressLabel.text = self.currentUser.email
        self.usernameLabel.text = self.currentUser.username
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        self.currentUser.logout()
        self.performSegue(withIdentifier: "logoutUser", sender: self)
    }

}
