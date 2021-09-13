//
//  LoginVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    var dimmingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = User.decodeUserDefaults() {
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if usernameTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "You must fill out all information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userTasker = UserTasker()
        userTasker.loginUser(username: usernameTextField.text!, password: passwordTextField.text!, failure: {(message) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                if let failureMessage = message {
                    let alert = UIAlertController(title: "Error", message: failureMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }, success: {(user) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        })
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }

}
