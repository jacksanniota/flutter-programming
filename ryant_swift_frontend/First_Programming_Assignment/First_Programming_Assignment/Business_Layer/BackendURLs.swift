//
//  BackendURLs.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import Foundation

class BackendURLs: NSObject {
    static let BASE_PATH = "http://127.0.0.1:8000"
    static let API_PATH = BASE_PATH + "/api"
    
    // Users
    static let REGISTER_USER_URL = API_PATH + "/register"
    static let LOGIN_USER_URL = API_PATH + "/login"
    
    // Postings
    static let CREATE_POSTING_URL = API_PATH + "/posting/create"
    static let GET_POSTINGS_URL = API_PATH + "/postings/all"
    static let UPVOTE_POSTING_URL = API_PATH + "/posting/upvote"
    static let DOWNVOTE_POSTING_URL = API_PATH + "/posting/downvote"
}
