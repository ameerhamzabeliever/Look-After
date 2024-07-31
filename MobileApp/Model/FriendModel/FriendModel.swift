//
//  FriendModel.swift
//  MobileApp
//
//  Created by Hamza's Mac on 09/11/2021.
//

import Foundation
import SwiftyJSON

struct FriendModel : Codable{
    let friendUserId : String
    let friendName   : String
    let friendPhoto  : String
    
    init(json: JSON){
        friendUserId = json["FriendUserId"]  .stringValue
        friendName   = json["FriendName"]    .stringValue
        friendPhoto  = json["ProfilePicture"].stringValue
    }
}
