//
//  UserTasker.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import Foundation

class UserTasker: NSObject {

    override init() {
        super.init()
    }
    
    func loginUser(username: String, password: String, failure: @escaping (_ message: String?) -> Void, success: @escaping (_ user: User?) -> Void) {
        let params = [
            "username" : username,
            "password" : password,
        ] as [String : Any]
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makePostRequest(forURL: BackendURLs.LOGIN_USER_URL, withParams: params, failure: {
            failure(nil)
        }, success: {(data, response) in
            if response.statusCode == 200 {
                if let user = User.parseJson(jsonData: data) {
                    user.saveToUserDefaults()
                    success(user)
                } else {
                    failure(nil)
                    return
                }
            } else if response.statusCode == 401 {
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    failure(nil)
                    return
                }
                failure(jsonResponse["message"] as? String)
            } else {
                failure(nil)
            }
        })
    }
    
    func registerUser(username: String, email: String, password: String, firstName: String, lastName: String, failure: @escaping () -> Void, success: @escaping (_ user: User?) -> Void) {
        let params = [
            "username" : username,
            "email" : email,
            "password" : password,
            "first_name" : firstName,
            "last_name" : lastName
        ] as [String : Any]
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makePostRequest(forURL: BackendURLs.REGISTER_USER_URL, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 201 {
                failure()
                return
            }
            if let user = User.parseJson(jsonData: data) {
                user.saveToUserDefaults()
                success(user)
            } else {
                failure()
            }
            
        })
    }
    
}
