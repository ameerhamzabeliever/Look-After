//
//  HelpRequests.swift
//  MobileApp
//
//  Created by Hamza's Mac on 28/12/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func createRequest(
        param            : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.createRequest,
            parameters: param,
            completion: completion)
    }
    func getUserRequests(
        user_id     : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ) {
        sendGetRequest(
            API : API.userRequests + "\(user_id)",
            completion: completion
        )
    }
    func getUserFriendsHelpRequests(
        user_id     : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ) {
        sendGetRequest(
            API : API.userFriendHelp + "\(user_id)",
            completion: completion
        )
    }
    func acceptRequest(
        requestId : String,
        userId : String,
        param            : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.acceptRequest + requestId + "&AcceptUserId=" + userId,
            parameters: param,
            completion: completion)
    }
    func deleteRequest(
        requestId : String,
        param            : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.deleteRequest + requestId,
            parameters: param,
            completion: completion)
    }
}
