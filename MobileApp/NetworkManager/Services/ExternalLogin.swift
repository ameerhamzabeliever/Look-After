//
//  ExternalLogin.swift
//  MobileApp
//
//  Created by Hamza's Mac on 31/12/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func registerExternal(
        param       : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    )
    {
        sendPostRequest(
            API : API.registerExternal,
            parameters: param,
            completion: completion)
    }
}
