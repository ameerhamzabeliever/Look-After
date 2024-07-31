//
//  ActivityModel.swift
//  MobileApp
//
//  Created by Hamza's Mac on 02/11/2021.
//

import Foundation
import SwiftyJSON

struct ActivityModel : Codable{
    let postedBy         : String
    let likesCount       : Int
    let activityComments : [ActivityCommentsModel]
    let postedUserId     : String
    let activityLikes    : [ActivityLikesModel]
    let min              : Int
    let day              : Int
    let hour             : Int
    let activityId       : Int
    let description      : String
    let commentCount     : Int
    let picture          : String
    let CreatedDateTime  : String
    
    init(json: JSON){
        postedBy         =  json["PostedBy"].stringValue
        likesCount       =  json["LikesCount"].intValue
        activityComments =  json["ActivityComments"].arrayValue.map({ActivityCommentsModel(json: $0)})
        postedUserId     =  json["PostedUserId"].stringValue
        activityLikes    =  json["ActivityLikes"].arrayValue.map({ActivityLikesModel(json: $0)})
        min              =  json["min"].intValue
        day              =  json["Day"].intValue
        hour             =  json["hour"].intValue
        activityId       =  json["Id"].intValue
        description      =  json["Description"].stringValue
        commentCount     =  json["CommentCount"].intValue
        picture          = json["Picture"].stringValue
        CreatedDateTime  = json["CreatedDateTime"].stringValue
    }
}

struct ActivityLikesModel : Codable {
    let activityId  : String
    let likedId     : Int
    let likedUserId : String
    let likedBy     : String
    
    init(json: JSON){
        activityId  = json["ActivityId"].stringValue
        likedId     = json["LikdeId"].intValue
        likedUserId = json["LikedUserId"].stringValue
        likedBy     = json["LikedBy"].stringValue
    }
}
struct ActivityCommentsModel : Codable {
    let comment_Desc  : String
    let hour     : Int
    let day     : Int
    let commentPostedUserId : String
    let commentPostedBy: String
    let commentId : String
    let activityId : String
    let min : Int
    let profilePicture : String
    let CreatedDateTime : String
    
    
    init(json: JSON){
        comment_Desc = json["CommentDescription"].stringValue
        hour         = json["hour"].intValue
        day          = json["Day"].intValue
        commentPostedUserId     = json["CmmentPostedUserId"].stringValue
        commentPostedBy         = json["CommentPostedBy"].stringValue
        commentId      = json["CommentId"].stringValue
        activityId     = json["ActivityId"].stringValue
        min            = json["min"].intValue
        profilePicture = json["ProfilePicture"].stringValue
        CreatedDateTime = json["CreatedDateTime"].stringValue
    }
}
