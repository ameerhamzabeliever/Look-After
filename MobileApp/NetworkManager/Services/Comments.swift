//
//  Comments.swift
//  MobileApp
//
//  Created by Hamza's Mac on 09/11/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func addComment(
        param            : [String: Any],
        activity         : String,
        comment_Desc     : String,
        user_Id          : String,
        creationDateTime : String,
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.addComment + "\(activity)" + "&Comment=\(comment_Desc)" + "&UserId=\(user_Id)" + "&CreatingDateTime=\(creationDateTime)",
            parameters: param,
            completion: completion)
    }
}
