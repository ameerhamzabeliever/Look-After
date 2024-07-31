//
//  Profile.swift
//  MobileApp
//
//  Created by Hamza's Mac on 11/11/2021.
//

import Foundation
import Alamofire
import UIKit

extension NetworkManager{
    func updateProfile(
        param       : [String : String],
        completion  : @escaping (DataResponse<String, AFError>) -> ()){
            sendPostRequestHeaders(
                API         : API.updateUserInfo,
                parameters  : param,
                completion  : completion
            )
        }
    func uploadPhoto(image       : UIImage?,
                     imageKey    : String,
                     completion  : @escaping (DataResponse<String, AFError>) -> ()){
        sendProfileUploadRequest(
            API         : API.uploadPicture,
            image       : image!,
            imageKey    : imageKey,
            completion  : completion
        )
    }
}
