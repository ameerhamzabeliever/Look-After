//
//  Friends.swift
//  MobileApp
//
//  Created by Hamza's Mac on 08/11/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func addFriend(
        param       : [String: Any],
        otherUserId : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.addFriends + "\(USER_ID)" + "&FriendUserId=\(otherUserId)",
            parameters: param,
            completion: completion)
    }
    func removeFriend(
        param       : [String: Any],
        user_id     : String,
        otherUserId : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.removeFriend + "\(user_id)" + "&FriendUserId=\(otherUserId)",
            parameters: param,
            completion: completion)
    }
    func getFriends(
        user_id     : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ) {
        sendGetRequest(
//            API  : API.getActivities + "\(DataManager.sharedInstance.user?.access_token)",
            API : API.getFriends + "\(user_id)",
            completion: completion
        )
    }
}
