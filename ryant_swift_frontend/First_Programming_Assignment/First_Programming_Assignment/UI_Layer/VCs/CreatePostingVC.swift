//
//  CreatePostingVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit
import CoreLocation

class CreatePostingVC: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {
    
    var currentUser: User!
    var locationManager: CLLocationManager!
    var currentLat: Float = 0.0
    var currentLong: Float = 0.0
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIButton!
    var dimmingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = User.decodeUserDefaults() else {
            return
        }
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.currentUser = user
        self.postTextView.delegate = self
        self.postTextView.text = "What's on your mind?"
        self.postTextView.textColor = UIColor.darkGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreatePostingVC.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.postTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.darkGray
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLat = Float(locValue.latitude)
        self.currentLong = Float(locValue.longitude)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        if self.postTextView.text?.isEmpty ?? true || self.postTextView.textColor == UIColor.darkGray {
            let alert = UIAlertController(title: "Error", message: "You can't post an empty message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.dismissKeyboard()
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userPostingTasker = UserPostingTasker()
        userPostingTasker.createUserPosting(user: self.currentUser, message: self.postTextView.text!, lat: self.currentLat, long: self.currentLong, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {(userPosting) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.postTextView.text = ""
                self.postTextView.text = "What's on your mind?"
                self.postTextView.textColor = UIColor.darkGray
                let alert = UIAlertController(title: "Success", message: "Your message has been posted!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
