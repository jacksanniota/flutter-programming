//
//  RegisterVC.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
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
    
    @IBAction func loginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if firstNameTextField.text?.isEmpty ?? true || lastNameTextField.text?.isEmpty ?? true || emailTextField.text?.isEmpty ?? true || usernameTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "You must fill out all information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        let userTasker = UserTasker()
        userTasker.registerUser(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {(user) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.performSegue(withIdentifier: "registerSuccess", sender: self)
            }
        })
    }

}
