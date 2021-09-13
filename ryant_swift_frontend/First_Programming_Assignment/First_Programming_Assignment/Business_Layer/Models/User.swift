//
//  User.swift
//  First_Programming_Assignment
//
//  Created by Ryan Tobin on 9/12/21.
//  Copyright © 2021 CS_4261_RyanT. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var pk: Int!
    var username: String!
    var email: String!
    var firstName: String!
    var lastName: String!
    
    init(pk: Int, username: String, email: String, firstName: String, lastName: String) {
        self.pk = pk
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let pk = aDecoder.decodeObject(forKey: "pk") as! Int
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.init(pk: pk, username: username, email: email, firstName: firstName, lastName: lastName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pk, forKey: "pk")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
    }
    
    func saveToUserDefaults() {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: "User")
        userDefaults.synchronize()
    }
    
    class func decodeUserDefaults() -> User? {
        let userDefaults = UserDefaults.standard
        guard let decoded = userDefaults.data(forKey: "User") else {
            return nil
        }
        guard let user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? User else {
            return nil
        }
        return user
    }
    
    class func parseJson(jsonData: Data) -> User? {
        guard let user_json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        let pk = user_json["pk"] as! Int
        let username = user_json["username"] as! String
        let email = user_json["email"] as! String
        let firstName = user_json["first_name"] as! String
        let lastName = user_json["last_name"] as! String
        return User(pk: pk, username: username, email: email, firstName: firstName, lastName: lastName)
    }
    
    func logout() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "User")
    }
    
}
