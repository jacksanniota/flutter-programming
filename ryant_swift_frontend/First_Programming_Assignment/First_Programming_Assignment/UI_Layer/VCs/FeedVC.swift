//
//  FeedVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit
import CoreLocation

class FeedVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let cellReuseID = "postCell"
    var postings: Array<UserPosting>!
    var dimmingView: UIView!
    var locationManager: CLLocationManager!
    var currentLat: Float = 0.0
    var currentLong: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postings = Array<UserPosting>()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        self.postings = Array<UserPosting>()
        self.getFeed()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLat = Float(locValue.latitude)
        self.currentLong = Float(locValue.longitude)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserPostingCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseID) as! UserPostingCell
        let posting = self.postings[indexPath.row]
        cell.dateLabel.text = posting.createdDate
        
        let myLocation = CLLocation(latitude: CLLocationDegrees(exactly: self.currentLat)!, longitude: CLLocationDegrees(exactly: self.currentLong)!)
        let postLocation = CLLocation(latitude: CLLocationDegrees(exactly: posting.locationLat)!, longitude: CLLocationDegrees(exactly: posting.locationLong)!)
        var distance = (myLocation.distance(from: postLocation) * 0.000621)
        distance = Double(round(distance * 100) / 100)
        cell.distanceLabel.text = String(distance) + " mi"
        
        cell.messageLabel.text = posting.message
        return cell
    }
    
    func getFeed() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userPostingTasker = UserPostingTasker()
        userPostingTasker.getAllUserPostings(failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.postings = Array<UserPosting>()
            }
        }, success: {(postingsData) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.postings = postingsData
                self.tableView.reloadData()
            }
        })
    }

}
