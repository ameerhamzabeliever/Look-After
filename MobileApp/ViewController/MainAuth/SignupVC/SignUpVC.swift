//
//  SignUpVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/15/21.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn

class SignUpVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    
    @IBOutlet weak var nameFld     : UITextField!
    @IBOutlet weak var emailFld    : UITextField!
    @IBOutlet weak var passwordFld : UITextField!
    @IBOutlet weak var passwordTxtFieldView : UIView!
    @IBOutlet weak var emailTxtFieldView    : UIView!
    @IBOutlet weak var userTxtFieldView     : UIView!
    @IBOutlet weak var createButton   : UIButton!
    @IBOutlet weak var keepMeImage    : UIImageView!
    @IBOutlet weak var signinLbl      : UILabel!
    @IBOutlet weak var keepSigninLbl  : UILabel!
    
    var accessToken: String? = nil
    var isKeepLogin = true
    var isSendEmail = true {
        didSet{
            print(isSendEmail)
        }
    }
    
    override func viewDidLoad() {
        setupTapGesture()
        designLayout()
    }
}

/* MARK:- Actions */
extension SignUpVC{
    @IBAction func signUpAction(_ sender: Any) {
        registerAccount()
    }
}

/* MARK:- API Methods */
extension SignUpVC{
    func registerAccount() {
        
        if isValid() {
            
            self.showLoading()
            var param = [String : Any]()
            param["Email"]           = self.emailFld.text!
            param["Password"]        = self.passwordFld.text!
            param["ConfirmPassword"] = self.passwordFld.text!
            param["UserTypeID"] = 1
            param["FirstName"]  = nameFld.text!
            param["lastName"]   = ""
            
            NetworkManager.PostAPI(jsonParam: param, WebServiceName: API.singUp, token: nil) { (status, errorMsg, responseData) in
                if status{
                    if let dataObj = responseData as? [String : AnyObject]  {
                        self.hideLoading()
                        if let error = dataObj["error_description"]   {
                            self.ShowErrorAlert(message: error as! String)
                        } else {
                            DispatchQueue.main.async {
                                self.PushViewWithStoryBoard(name: ViewControllerName.Names.signIn, StoryBoard: Storyboard.Ids.main)
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
            }
            
        }
    }
}

/* MARK:- Extension */
extension SignUpVC{
    func designLayout(){
        userTxtFieldView    .layer.cornerRadius = 12
        emailTxtFieldView   .layer.cornerRadius = 12
        passwordTxtFieldView.layer.cornerRadius = 12
        nameFld             .layer.cornerRadius = 12
        emailFld            .layer.cornerRadius = 12
        passwordFld         .layer.cornerRadius = 12
        createButton        .layer.cornerRadius = 10
        keepMeImage         .layer.cornerRadius = 4
    }
    
    func setupTapGesture(){
        keepMeImage.isUserInteractionEnabled = true
        keepMeImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(rememberMe)))
        
        keepSigninLbl.isUserInteractionEnabled = true
        keepSigninLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(rememberMe)))
        
        signinLbl.isUserInteractionEnabled = true
        signinLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToSignIn)))
    }
    
    func isValid() -> Bool {
        guard let name  = self.nameFld.text, !name.isEmpty else {
            self.ShowErrorAlert(message: MessageConstant.enterName, AlertTitle: MessageConstant.empty)
            return false
        }
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
        guard password.hasSpecialCharacters() else {
            self.ShowErrorAlert(message: MessageConstant.specialCharacter, AlertTitle: MessageConstant.empty)
            return false
        }
        guard password.hasUppercaseCharacters() else {
            self.ShowErrorAlert(message: MessageConstant.upperCharacter, AlertTitle: MessageConstant.empty)
            return false
        }
        return true
    }
    @objc func rememberMe(_ tap : UITapGestureRecognizer){
        if isKeepLogin {
            keepMeImage.image = nil
        } else {
            keepMeImage.image = UIImage(systemName: "checkmark")
        }
        isKeepLogin = !isKeepLogin
    }
    
    
    @objc func navigateToSignIn(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.signIn, StoryBoard: Storyboard.Ids.main)
    }
}
