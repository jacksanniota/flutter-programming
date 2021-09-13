//
//  UserPosting.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import Foundation

class UserPosting: NSObject {
    
    var pk: Int!
    var poster: User!
    var message: String!
    var createdDate: String!
    var voteCount: Int!
    var locationLat: Float!
    var locationLong: Float!
    
    init(pk: Int, poster: User, message: String, createdDate: String, voteCount: Int, locationLat: Float, locationLong: Float) {
        self.pk = pk
        self.poster = poster
        self.message = message
        self.createdDate = createdDate
        self.voteCount = voteCount
        self.locationLat = locationLat
        self.locationLong = locationLong
    }

    class func parseJson(jsonData: Data) -> UserPosting? {
        guard let posting_json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        let pk = posting_json["pk"] as! Int
        guard let user_json = try? JSONSerialization.data(withJSONObject: posting_json["poster"] as! [String: Any], options: []) else {
            return nil
        }
        let poster = User.parseJson(jsonData: user_json)!
        let message = posting_json["message"] as! String
        let createdDate = posting_json["created_date"] as! String
        let voteCount = posting_json["vote_count"] as! Int
        let locationLat = posting_json["lat"] as! Float
        let locationLong = posting_json["long"] as! Float
        return UserPosting(pk: pk, poster: poster, message: message, createdDate: createdDate, voteCount: voteCount, locationLat: locationLat, locationLong: locationLong)
    }

}
