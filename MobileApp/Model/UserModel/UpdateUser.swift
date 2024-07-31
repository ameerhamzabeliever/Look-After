//
//  UpdateUser.swift
//  MobileApp
//
//  Created by Hamza's Mac on 11/11/2021.
//

import Foundation
import SwiftyJSON

struct UpdateUser : Codable{
    var UserID : String
    var FirstName : String
    var LastName : String
    var Email : String
    var AspNetUserID : String
    var ProfilePicture : String
    
    init(json: JSON){
        UserID           =  json["UserID"].stringValue
        FirstName        =  json["FirstName"].stringValue
        LastName         =  json["LastName"].stringValue
        Email            =  json["Email"].stringValue
        AspNetUserID     =  json["AspNetUserID"].stringValue
        ProfilePicture   =  json["ProfilePicture"].stringValue
    }
}
