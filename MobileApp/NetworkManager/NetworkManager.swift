//
//  NetworkManager.swift
//  MobileApp
//
//  Created by TecSpine on 15/09/2021.
//


import Alamofire
import GCNetworkReachability
import CoreLocation

class NetworkManager: NSObject {
    
    /// shared Instance for NetworkManager
    static let sharedInstance = NetworkManager()
    
    class func isNetworkReachable() -> Bool {
        let reachablity = GCNetworkReachability(internetAddressString: "www.google.com")
        let reachable = reachablity?.isReachable()
        reachablity?.stopMonitoringNetworkReachability()
        return reachable!
    }
    
    private class func sendJSONToServer(
        jsonParam: [String: Any]?,
        webserviceName: String,
        isPostRequest: Int = 1,
        token: String?,
        completion: @escaping (_ success: Bool, _ message: String, _ response: Any) -> Void) -> Request? {
        
        let json = jsonParam
        let headers: HTTPHeaders? = [.authorization(bearerToken: token ?? "")]
        
        if NetworkManager.isNetworkReachable() {
            let postURLString = BaseURL + webserviceName
            
            var apiCall : HTTPMethod = .get
            
            if isPostRequest == 1 {
                apiCall = .post
            }else if isPostRequest == 2 {
                apiCall = .delete
            }else if isPostRequest == 3 {
                apiCall = .put
            }
            
            print("api type ", apiCall)
            print("api url ", postURLString)
            print("api params ", json as Any)
            
            AF.request(postURLString,
                       method: apiCall,
                       parameters: json,
                       headers : headers).responseJSON(completionHandler: { (response) in
                if response.data != nil {
                    completion(true, "", (self.nsdataToJSON(data: response.data!)))
                }else {
                    print("api response: Data is nil ")
                    completion(false, MessageConstant.networkNotAvailableMessage, ["message" : MessageConstant.networkNotAvailableMessage])
                }
            })
            
        }else {
            completion(false, MessageConstant.networkNotAvailableMessage, ["message" : MessageConstant.networkNotAvailableMessage])
        }
        return nil
    }
    
    class func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
            print("api response ", jsonData)
            return jsonData
        } catch let myJSONError {
            print("api response data could not serialize ", myJSONError)
            print(myJSONError)
        }
        return nil
    }
    
    class func GetAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, token: String?, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 0, token: token) { (success, message, response) -> Void in
            completion(success, message , response)
        }
    }
    
    class func PostAPI(jsonParam: [String: Any]?, WebServiceName : String, token: String?, completion: @escaping (_ success: Bool, _ message: String , _ response:Any) -> Void ) {
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 1, token: token) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    class func fetchDataGetURL(MainURL : String , Completion:@escaping (Swift.Result<Any, Error>)->()) {
        let url = URL(string:MainURL)
        let request = AF.request(url!, method: .get)
        request.responseJSON(completionHandler: { response in
            guard response.error == nil else {
                Completion(.failure(response.error!))
                return
            }
            do {
                switch response.result  {
                case .success(let resp):
                    Completion(.success(resp))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    class func DeleteAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, token: String?, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 2 ,token: token) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    class func PutAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, token: String?, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 3, token: token) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    class func PostUserImageAPI(jsonParam: [String: Any]?, WebServiceName : String, imageMain : UIImage?,_ imageKey: String = "profile_image", completion: @escaping (_ success: Bool, _ message: String , _ response: Any?) -> Void ) {
        
        var headers = [String : String]()
        let url = BaseURL + WebServiceName
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in jsonParam! {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            if imageMain != nil {
                if let imageData = imageMain!.jpegData(compressionQuality: 0.6) {
                    multipartFormData.append(imageData, withName: imageKey, fileName: "a.jpg", mimeType: "image/jpeg")
                }
            }
            
        }, to: url)
        
            .responseString{ response in
                print("response ===>")
                print(response)
                print("response.result ===> ")
                print(response.result)
                print("response.error ===> ")
                print(response.error as Any)
                if response.error == nil {
                    completion(true,"", self.nsdataToJSON(data: response.data!))
                }else {
                    completion(false, response.error.debugDescription, nil)
                }
            }
    }
    func sendGetRequest(
        API: String,
        completion: @escaping (DataResponse<String, AFError>) -> Void
    ) -> Void {
        AF.request(
            BaseURL + API,
            method: .get
        ).responseString { response in
            completion(response)
        }
    }
    func sendGetRequestHeaders(
        API        : String,
        completion : @escaping (DataResponse<String, AFError>) -> Void
    ) -> Void {
        let headers = httpHeadersToken
        AF.request(
            BaseURL + API,
            method  : .get,
            headers : headers
        ).responseString { response in
            completion(response)
        }
    }
    
    func sendPostRequest(
        API         : String,
        parameters  : Parameters,
        encoderRequest: URLEncoding = URLEncoding.default,
        completion  : @escaping (DataResponse<String, AFError>) -> Void
    ){
        AF.request(
            BaseURL + API.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
            method      : .post,
            parameters  : parameters,
            encoding    : encoderRequest
        ).responseString { (response) in
            completion(response)
        }
    }
    
    func sendPostRequestHeaders(
        API         : String,
        parameters  : Parameters,
        completion  : @escaping (DataResponse<String, AFError>) -> Void
    ){
        let headers = httpHeadersToken
        AF.request(
            BaseURL + API.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
            method      : .post,
            parameters  : parameters,
            encoding    : URLEncoding.default,
            headers     : headers
        ).responseString { (response) in
            completion(response)
        }
    }
    ///UPLOAD
    func sendProfileUploadRequest(
        API        : String,
        image      : UIImage,
        imageKey   : String ,
        completion : @escaping (DataResponse<String, AFError>) -> Void
    ){
        AF.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(
                    imageData,
                    withName: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpg")
            }
        }, to      : BaseURL + API.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
           method  : .post,
           headers : httpHeadersToken
        ).responseString { response in
            completion(response)
        }
    }
}
