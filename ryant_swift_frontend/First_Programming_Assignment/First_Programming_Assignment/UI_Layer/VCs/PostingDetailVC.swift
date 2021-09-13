//
//  PostingDetailVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/13/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit

class PostingDetailVC: UIViewController {
    
    @IBOutlet var posterLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var downvoteButton: UIButton!
    var dimmingView: UIView!
    var currentPosting: UserPosting!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.posterLabel.text = currentPosting.poster.firstName + " " + currentPosting.poster.lastName
        self.dateLabel.text = currentPosting.createdDate
        self.messageTextView.text = currentPosting.message
        self.voteCountLabel.text = String(currentPosting.voteCount) + " votes"
    }
    
    
    @IBAction func upvotePost(_ sender: UIButton) {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userPostingTasker = UserPostingTasker()
        userPostingTasker.upvotePosting(posting: self.currentPosting, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {(posting) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.currentPosting = posting
                self.voteCountLabel.text = String(self.currentPosting.voteCount) + " votes"
            }
        })
    }
    
    @IBAction func downvotePost(_ sender: UIButton) {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userPostingTasker = UserPostingTasker()
        userPostingTasker.downvotePosting(posting: self.currentPosting, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {(posting) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.currentPosting = posting
                self.voteCountLabel.text = String(self.currentPosting.voteCount) + " votes"
            }
        })
    }

}
