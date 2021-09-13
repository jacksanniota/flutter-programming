//
//  UserPostingTasker.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import Foundation

class UserPostingTasker: NSObject {

    override init() {
        super.init()
    }
    
    func createUserPosting(user: User, message: String, lat: Float, long: Float, failure: @escaping () -> Void, success: @escaping (_ userPosting: UserPosting?) -> Void) {
        let params = [
            "user_pk" : user.pk!,
            "message" : message,
            "lat" : lat,
            "long" : long
        ] as [String : Any]
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makePostRequest(forURL: BackendURLs.CREATE_POSTING_URL, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 201 {
                failure()
                return
            }
            let userPosting = UserPosting.parseJson(jsonData: data)
            success(userPosting)
        })
    }
    
    func upvotePosting(posting: UserPosting, failure: @escaping () -> Void, success: @escaping (_ userPosting: UserPosting?) -> Void) {
        let params = [
            "posting_pk" : posting.pk!,
        ] as [String : Any]
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makePostRequest(forURL: BackendURLs.UPVOTE_POSTING_URL, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            let userPosting = UserPosting.parseJson(jsonData: data)
            success(userPosting)
        })
    }
    
    func downvotePosting(posting: UserPosting, failure: @escaping () -> Void, success: @escaping (_ userPosting: UserPosting?) -> Void) {
        let params = [
            "posting_pk" : posting.pk!,
        ] as [String : Any]
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makePostRequest(forURL: BackendURLs.DOWNVOTE_POSTING_URL, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            let userPosting = UserPosting.parseJson(jsonData: data)
            success(userPosting)
        })
    }
    
    func getAllUserPostings(failure: @escaping () -> Void, success: @escaping (_ userPostings: Array<UserPosting>?) -> Void) {
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makeGetRequest(forBaseURL: BackendURLs.GET_POSTINGS_URL, withParams: [String: Any](), failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            guard let postings = try? JSONSerialization.jsonObject(with: data) as? Array<[String: Any]> else {
                failure()
                return
            }
            var userPostings = Array<UserPosting>()
            for posting in postings {
                guard let posting_data = try? JSONSerialization.data(withJSONObject: posting, options: []) else {
                    continue
                }
                if let parsedUserPosting = UserPosting.parseJson(jsonData: posting_data) {
                    userPostings.append(parsedUserPosting)
                }
            }
            success(userPostings)
        })
    }
}
