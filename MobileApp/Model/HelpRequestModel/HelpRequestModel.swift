//
//  HelpRequestModel.swift
//  MobileApp
//
//  Created by TecSpine on 10/12/2021.
//

import Foundation
import SwiftyJSON

struct HelpRequestModel: Codable {
    let helpReqId    : Int?
    let createUserID : String?
    var description, createdDate, startingDate, endingDate: String?
    let aceptedUserID: String?
    let statusName   : String?
    let helpRequestCreaterUserName: String?
    let photo : String
    
    init(json: JSON){
        helpReqId      = json["Id"]  .intValue
        createUserID   = json["CreateUserId"]    .stringValue
        description    = json["Description"].stringValue
        createdDate    = json["CreatedDate"]    .stringValue
        startingDate   = json["StartingDate"].stringValue
        endingDate     = json["EndingDate"]    .stringValue
        aceptedUserID  = json["AceptedUserId"].stringValue
        statusName     = json["StatusName"]    .stringValue
        helpRequestCreaterUserName  = json["HelpRequestCreaterUserName"].stringValue
        photo = json["ProfilePicture"].stringValue
    }
}
