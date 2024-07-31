//
//  ForgetPassword.swift
//  MobileApp
//
//  Created by Hamza's Mac on 29/12/2021.
//

import Foundation
import Alamofire

extension NetworkManager{
    func generateOtpForEmail(
        email       : String,
        param       : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.generateOtp + email,
            parameters: param,
            completion: completion)
    }
    func verifyOtp(
        Otp       : String,
        id        : String,
        param       : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.verifyOtp + Otp + "&Id=" + id,
            parameters: param,
            completion: completion)
    }
    func updateUserPassword(
        param       : [String: Any],
        completion  : @escaping (DataResponse<String, AFError>) -> ()
    ){
        sendPostRequest(
            API : API.updatePassword,
            parameters: param,
            completion: completion)
    }
}
