//
//  UserModel.swift
//  MobileApp
//
//  Created by TecSpine on 15/09/2021.
//

import Foundation
import UIKit


class UserModel: ResponseModel , NSCoding {

    var UserID = ""
    var FirstName = ""
    var LastName = ""
    var Email = ""
    var AspNetUserID = ""
    var ProfilePicture = ""
    var Otp = ""
    var isVerified = ""
    var myRequestCount = ""
    var friendsRequestCount = ""

    convenience init(json: [String: AnyObject]?) {
        self.init()

        if  json != nil {
            self.UserID = self.ReturnValue(value: json!["UserID"] as Any)
            self.FirstName = self.ReturnValue(value: json!["FirstName"] as Any)
            self.LastName = self.ReturnValue(value: json!["LastName"] as Any)
            self.Email = self.ReturnValue(value: json!["Email"] as Any)
            self.AspNetUserID = self.ReturnValue(value: json!["AspNetUserID"] as Any)
            self.ProfilePicture = self.ReturnValue(value: json!["ProfilePicture"] as Any)
            self.Otp = self.ReturnValue(value: json!["OTP"] as Any)
            self.isVerified = self.ReturnValue(value: json!["IsVerified"] as Any)
            self.myRequestCount = self.ReturnValue(value: json!["MyHelpRequest"] as Any)
            self.friendsRequestCount = self.ReturnValue(value: json!["FriendHelpRequest"] as Any)
        }

    }

    func encode(with aCoder: NSCoder) {

        aCoder.encode(self.UserID, forKey: "UserID")
        aCoder.encode(self.FirstName, forKey: "FirstName")
        aCoder.encode(self.LastName, forKey: "LastName")
        aCoder.encode(self.Email, forKey: "Email")
        aCoder.encode(self.AspNetUserID, forKey: "AspNetUserID")
        aCoder.encode(self.ProfilePicture, forKey: "ProfilePicture")
        aCoder.encode(self.Otp, forKey: "OTP")
        aCoder.encode(self.isVerified, forKey: "IsVerified")
        aCoder.encode(self.myRequestCount, forKey: "MyHelpRequest")
        aCoder.encode(self.friendsRequestCount, forKey: "FriendHelpRequest")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()

        self.UserID = aDecoder.decodeObject(forKey:"UserID") as? String ?? MessageConstant.empty
        self.FirstName = aDecoder.decodeObject(forKey:"FirstName") as? String ?? MessageConstant.empty
        self.LastName = aDecoder.decodeObject(forKey:"LastName") as? String ?? MessageConstant.empty
        self.Email = aDecoder.decodeObject(forKey:"Email") as? String ?? MessageConstant.empty
        self.AspNetUserID = aDecoder.decodeObject(forKey:"AspNetUserID") as? String ?? MessageConstant.empty
        self.ProfilePicture = aDecoder.decodeObject(forKey:"ProfilePicture") as? String ?? MessageConstant.empty
        self.Otp = aDecoder.decodeObject(forKey:"OTP") as? String ?? MessageConstant.empty
        self.isVerified = aDecoder.decodeObject(forKey:"IsVerified") as? String ?? MessageConstant.empty
        self.myRequestCount = aDecoder.decodeObject(forKey:"MyHelpRequest") as? String ?? MessageConstant.empty
        self.friendsRequestCount = aDecoder.decodeObject(forKey:"FriendHelpRequest") as? String ?? MessageConstant.empty
    }
}
