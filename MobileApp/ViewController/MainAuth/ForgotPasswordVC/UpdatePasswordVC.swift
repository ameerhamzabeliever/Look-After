//
//  UpdatePasswordVC.swift
//  MobileApp
//
//  Created by Hamza's Mac on 29/12/2021.
//

import UIKit
import SwiftyJSON

class UpdatePasswordVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var textFieldPass        : UITextField!
    @IBOutlet weak var textFieldConfirmPass : UITextField!
    @IBOutlet weak var btnUpdate            : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}

/* MARK:- Actions */
extension UpdatePasswordVC{
    @IBAction func didTapBack(_ sender: UIButton){
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func didTapUpdatePassword(_ sender: UIButton){
        if isValid(){
            updatePassword(pass: textFieldPass.text ?? "", confirmPass: textFieldConfirmPass.text ?? "")
        }
    }
}
/* MARK:- Extension */
extension UpdatePasswordVC{
    func setLayout(){
        btnUpdate.layer.cornerRadius = 5.0
    }
    func isValid() -> Bool{
        if textFieldPass.text == "" || textFieldConfirmPass.text == ""{
            self.ShowErrorAlert(message: "Fields cannot be empty")
            return false
        }
        if textFieldPass.text != textFieldConfirmPass.text{
            self.ShowErrorAlert(message: "Please reconfirm your password")
            return false
        }
        return true
    }
    func updatePassword(pass: String,  confirmPass: String){
        var parameters : [String: Any] = [:]
        parameters["AspNetUserId"] = DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID
        parameters["Password"]        = pass
        parameters["ConfirmPassword"] = confirmPass
        showLoading()
        NetworkManager.sharedInstance.updateUserPassword(param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            self.PushViewWithStoryBoard(name: ViewControllerName.Names.signIn, StoryBoard: Storyboard.Ids.main)
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
