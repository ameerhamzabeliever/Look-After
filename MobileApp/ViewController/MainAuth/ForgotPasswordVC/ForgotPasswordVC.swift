//
//  ForgotPasswordVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/20/21.
//

import Foundation
import UIKit
import SwiftyJSON

class ForgotPasswordVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var centreView  : UIView!
    @IBOutlet weak var emailTF     : UITextField!
    @IBOutlet weak var resetButton : UIButton!
    @IBOutlet weak var loginLbl    : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designLayout()
        setupTapGesture()
        
    }
}

/* MARK:- Actions */
extension ForgotPasswordVC{
    @IBAction func didTapSendOtp(_ sender : UIButton){
        guard let email = self.emailTF.text, email != "" else{
            self.ShowErrorAlert(message: "Email cannot be empty")
            return
        }
        guard email.isValidEmail else {
            self.ShowErrorAlert(message: MessageConstant.valideEmail, AlertTitle: MessageConstant.empty)
            return
        }
        generateOtp(email: email)
    }
}

/* MARK:- Extensions */
extension ForgotPasswordVC{
    func designLayout()  {
        centreView.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
        emailTF.layer.cornerRadius = 10
    }
    func setupTapGesture()
    {
        loginLbl.isUserInteractionEnabled = true
        loginLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToSignIn)))
    }
    @objc func navigateToSignIn(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.signIn, StoryBoard: Storyboard.Ids.main)
    }
    func generateOtp(email: String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["Email"]   = email
        
        NetworkManager.sharedInstance.generateOtpForEmail(email: email, param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let jsonData = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as AnyObject
                            let apiData = jsonData as! [String : AnyObject]
                            print(apiData)
                            let user = UserModel(json: apiData["data"] as! [String : AnyObject])
                            DataManager.sharedInstance.user = user
                            DataManager.sharedInstance.saveUserPermanentally()
                            self.PushViewWithStoryBoard(name: ViewControllerName.Names.otpVC, StoryBoard: Storyboard.Ids.main)
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
