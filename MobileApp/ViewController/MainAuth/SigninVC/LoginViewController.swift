//
//  loginViewController.swift
//  MobileApp
//
//  Created by TecSpine on 9/14/21.
//

import Foundation
import UIKit
import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn

class LoginViewController: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var appleView         : UIView!
    @IBOutlet weak var emailSatckView    : UIView!
    @IBOutlet weak var googleView      : UIView!
    @IBOutlet weak var passwordStackView : UIView!
    @IBOutlet weak var loginViewRad      : UIView!
    @IBOutlet weak var loginButton       : UIButton!
    
    @IBOutlet weak var forgotPasswordLbl : UILabel!
    @IBOutlet weak var signupLbl         : UILabel!
    
    @IBOutlet weak var emailFld          : UITextField!
    @IBOutlet weak var passwordFld       : UITextField!
    
    let appleButton = ASAuthorizationAppleIDButton()
    var accessToken: String? = nil
    
    override func viewDidLoad() {
        UserDefaults.standard.set(true, forKey: "isVisited")
        setUpView()
        setUpTapGesture()
    }
}

/* MARK:- Actions */
extension LoginViewController{
    @IBAction func loginAction(_ sender: Any) {
        loginAccount()
    }
}

/* MARK:- API Methods */
extension LoginViewController{
    func loginAccount() {
        if isValid() {
            self.showLoading()
            var param = [String : Any]()
            param["username"]   = self.emailFld.text!
            param["Password"]   = self.passwordFld.text!
            param["grant_type"] = "password"
            
            NetworkManager.PostAPI(jsonParam: param, WebServiceName: API.singIn, token: nil) { (status, errorMsg, responseData) in
                if status{
                    if let dataObj = responseData as? [String : AnyObject]  {
                        self.hideLoading()
                        if let error = dataObj["error_description"]   {
                            self.ShowErrorAlert(message: error as! String)
                        } else {
                            self.getUserDetail(token: dataObj["access_token"] as! String, tokenType: dataObj["token_type"] as! String)
                        }
                    } else {
                        self.hideLoading()
                        self.ShowErrorAlert(message: errorMsg)
                    }
                } else {
                    self.hideLoading()
                    self.ShowErrorAlert(message: errorMsg)
                }
            }
        }
    }
    @objc func googleLogin() {
        let signInConfig = GIDConfiguration.init(clientID: "616409329506-9co5d9gecceleheon753v0mqs7s6og5q.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self){ user, error in
            if let error = error {
                self.showToast(message: "\(error.localizedDescription)")
            }else {
                let idToken = user?.authentication.accessToken ?? ""
                if idToken != "" {
                    self.registerExternal(email: user?.profile?.email ?? "", provider: "Google", providerKey: idToken ?? "", firstName: user?.profile?.givenName ?? "", lastName: user?.profile?.familyName ?? "")

                }
            }
        }
    }
    /// not using anywhere
    @objc func facebookLogin() {
        print("Facebook")
        showLoading()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            print(loginResult)
            self.hideLoading()
            switch loginResult {
            case .failed(let error):
                self.ShowSuccessAlert(message: error.localizedDescription)
                print(error)
                break
            case .cancelled:
                print("Cancelled")
                break
            case .success(_ , _, let accessToken):
                print("FaceBook_Auth" , accessToken?.tokenString)
                self.registerExternal(email: Profile.current?.email ?? "", provider: "Facebook", providerKey: accessToken?.userID ?? "", firstName: Profile.current?.firstName ?? "", lastName: Profile.current?.lastName ?? "")
                self.accessToken = accessToken?.tokenString
                break
            }
        }
    }
    @objc func appleLogin(){
        AppleSignin.shared.initAppleSignin(scope: [.email, .fullName]) { (appleData) in
            self.accessToken = appleData.userId
            print("token", appleData.userId,
                  appleData.firstName!,
                  appleData.email ?? "")
            if appleData.error == nil {
                self.registerExternal(email: appleData.email ?? "", provider: "Apple", providerKey: appleData.userId ?? "", firstName: appleData.firstName ?? "", lastName: appleData.lastName ?? "")
            }
        }
    }
    
    func getUserDetail(token: String, tokenType: String) {
        self.showLoading()
        
        NetworkManager.GetAPI(jsonParam: nil, WebServiceName: API.getInfo, token: token, completion: { (status, errorMsg, responseData) in
            if status{
                if var dataObj = responseData as? [String : AnyObject]  {
                    self.hideLoading()
                    if let error = dataObj["error_description"]   {
                        self.ShowErrorAlert(message: error as! String)
                    } else {
                        dataObj["access_token"] = token as AnyObject
                        dataObj["token_type"] = tokenType as AnyObject
                        UserDefaults.standard.set("Bearer \(token)", forKey: userDefaults.HTTP_HEADERS)
                        let userMain = UserModel(json: dataObj)
                        DataManager.sharedInstance.user = userMain
                        DataManager.sharedInstance.saveUserPermanentally()
                        DispatchQueue.main.async {
                            if COME_FROM_LINK{
                                let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
                                let friend_vc = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.tabbar) as! TabBarVC
                                friend_vc.selectedIndex = 3
                                self.navigationController!.pushViewController(friend_vc, animated: true)
                            }
                            else{
                                self.PushViewWithStoryBoard(name: ViewControllerName.Names.tabbar, StoryBoard: Storyboard.Ids.home)
                            }
                        }
                    }
                    
                } else {
                    self.hideLoading()
                    self.ShowErrorAlert(message: errorMsg)
                }
            } else {
                self.hideLoading()
                self.ShowErrorAlert(message: errorMsg)
            }
        })
    }
    func registerExternal(email : String, provider: String, providerKey: String, firstName: String, lastName: String){
//        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["Email"]   = email
        parameters["Provider"]   = provider
        parameters["ProviderKey"]   = providerKey
        parameters["FirstName"]   = firstName
        parameters["LastName"]   = lastName
        print(parameters)
        NetworkManager.sharedInstance.registerExternal(param: parameters){
            (response) in
//            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let jsonData = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as AnyObject
                            let apiData = jsonData as! [String : AnyObject]
                            print(apiData)
                            let code = apiData["Code"]
                            if code as! Int == 400{
                                self.ShowErrorAlert(message: "Please remove Village Maker from Settings -> Your Apple ID -> Password & Security -> Apps Using Apple ID and create the account again by sharing your Email.")
                            }
                            else if code as! Int == 200{
                                UserDefaults.standard.set("Bearer \(apiData["token"]!)", forKey: userDefaults.HTTP_HEADERS)
                                let dataObj = apiData["data"]
                                let userMain = UserModel(json: dataObj as! [String : AnyObject])
                                DataManager.sharedInstance.user = userMain
                                DataManager.sharedInstance.saveUserPermanentally()
                                DispatchQueue.main.async {
                                    if COME_FROM_LINK{
                                        let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
                                        let friend_vc = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.tabbar) as! TabBarVC
                                        friend_vc.selectedIndex = 3
                                        self.navigationController!.pushViewController(friend_vc, animated: true)
                                    }
                                    else{
                                        self.PushViewWithStoryBoard(name: ViewControllerName.Names.tabbar, StoryBoard: Storyboard.Ids.home)
                                    }
                                }
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }

    }
}

/* MARK:- Extensions */
extension LoginViewController{
    func setUpView(){
        loginButton .layer.cornerRadius = 5
        appleView   .layer.cornerRadius = 8
        googleView  .layer.cornerRadius = 8
        loginViewRad.clipsToBounds = true
        loginViewRad.layer.cornerRadius = 12
        loginViewRad.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        emailSatckView   .layer.cornerRadius = 8
        passwordStackView.layer.cornerRadius = 8
    }
    
    func setUpTapGesture(){
        signupLbl.isUserInteractionEnabled = true
        signupLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToSignUp)))
        forgotPasswordLbl.isUserInteractionEnabled = true
        forgotPasswordLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToForgot)))
        
        appleView.isUserInteractionEnabled = true
        appleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(appleLogin)))
        googleView.isUserInteractionEnabled = true
        googleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleLogin)))
    }
    
    func isValid() -> Bool {
        guard let email = self.emailFld.text, !email.isEmpty else {
            self.ShowErrorAlert(message: MessageConstant.enterEmail, AlertTitle: MessageConstant.empty)
            return false
        }
        guard email.isValidEmail else {
            self.ShowErrorAlert(message: MessageConstant.valideEmail, AlertTitle: MessageConstant.empty)
            return false
        }
        guard let password = self.passwordFld.text, !password.isEmpty else {
            self.ShowErrorAlert(message: MessageConstant.enterPassword, AlertTitle: MessageConstant.empty)
            return false
        }
        guard password.count > 8 else {
            self.ShowErrorAlert(message: MessageConstant.tooShortPassword, AlertTitle: MessageConstant.empty)
            return false
        }
        return true
    }
    @objc func navigateToSignUp(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.signUp, StoryBoard: Storyboard.Ids.main)
    }
    @objc func navigateToForgot(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.forgotPasswordVC, StoryBoard: Storyboard.Ids.main)
    }
}
