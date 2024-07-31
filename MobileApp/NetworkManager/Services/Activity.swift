//
//  Activity.swift
//  MobileApp
//
//  Created by Hamza's Mac on 02/11/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func getActivities(
        user_id     : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ) {
        sendGetRequest(
//            API  : API.getActivities + "\(DataManager.sharedInstance.user?.access_token)",
            API : API.getActivities + "\(user_id)",
            completion: completion
        )
    }
    func createActivity(
        param         : [String: Any],
        user_id       : String,
        dateTime      : String,
        activity_desc : String,
        completion    : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.createActivity + "\(user_id)" + "&DateTime=\(dateTime)" + "&description=\(activity_desc)",
            parameters: param,
            completion: completion)
    }
    func deleteActivity(
        param       : [String: Any],
        activityId  : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    )
    {
        sendPostRequest(
            API : API.deleteActivty + "\(activityId)",
            parameters: param,
            completion: completion)
    }
    func likeActivity(
        param       : [String: Any],
        userId      : String,
        activityId  : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    )
    {
        sendPostRequest(
            API : API.likeActivity + "\(userId)&ActivityId=\(activityId)",
            parameters: param,
            completion: completion)
    }
    func unlikeActivity(
        param       : [String: Any],
        userId      : String,
        activityId  : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    )
    {
        sendPostRequest(
            API : API.unlikeActivity + "\(userId)&ActivityId=\(activityId)",
            parameters: param,
            completion: completion)
    }

}
