//
//  OtpVC.swift
//  MobileApp
//
//  Created by Hamza's Mac on 29/12/2021.
//

import UIKit
import SwiftyJSON

class OtpVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var textField1 : UITextField!
    @IBOutlet weak var textField2 : UITextField!
    @IBOutlet weak var textField3 : UITextField!
    @IBOutlet weak var textField4 : UITextField!
    @IBOutlet weak var textField5 : UITextField!
    @IBOutlet weak var textField6 : UITextField!
    @IBOutlet weak var btnVerify  : UIButton!
    @IBOutlet weak var lblResend  :  UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTapGesture()
        print(DataManager.sharedInstance.getPermanentlySavedUser()?.Otp)
    }
}

/* MARK:- Actions */
extension OtpVC{
    @IBAction func didTapBack(_ sender: UIButton){
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func didTapVerify(_ sender: UIButton){
        if isValid(){
            let exp1 =
                textField1.text! + textField2.text! + textField3.text!
            let exp2 = textField4.text! + textField5.text! + textField6.text!
            let otp = exp1 + exp2
            verifyOTP(Otp: otp, id: DataManager.sharedInstance.getPermanentlySavedUser()!.UserID)
        }
    }
}

/* MARK:- UITextFieldDelegate*/
extension OtpVC : UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        var text = textField.text!
        if text.utf16.count == 0 {
            switch textField {
            case textField2:
                textField1.isUserInteractionEnabled = true
                textField1.becomeFirstResponder()
            case textField3:
                textField2.isUserInteractionEnabled = true
                textField2.becomeFirstResponder()
            case textField4:
                textField3.isUserInteractionEnabled = true
                textField3.becomeFirstResponder()
            case textField5:
                textField4.isUserInteractionEnabled = true
                textField4.becomeFirstResponder()
            case textField6:
                textField5.isUserInteractionEnabled = true
                textField5.becomeFirstResponder()
            default:
                break
            }
        }
        else if text.utf16.count >= 1 {
            if text.utf16.count == 2{
                let str =  text
                let arr = str.map { String($0) }
                print(arr)
                text = arr[1]
                switch textField {
                case textField1:
                    textField1.text = ""
                    textField1.text = text
                    textField2.isUserInteractionEnabled = true
                    textField2.becomeFirstResponder()
                case textField6:
                    textField6.text = ""
                    textField6.text = text
                default:
                    break
                }
            }
            switch textField {
            case textField1:
                textField1.isUserInteractionEnabled = false
                textField2.isUserInteractionEnabled = true
                textField2.becomeFirstResponder()
            case textField2:
                textField2.isUserInteractionEnabled = false
                textField3.isUserInteractionEnabled = true
                textField3.becomeFirstResponder()
            case textField3:
                textField3.isUserInteractionEnabled = false
                textField4.isUserInteractionEnabled = true
                textField4.becomeFirstResponder()
            case textField4:
                textField4.isUserInteractionEnabled = false
                textField5.isUserInteractionEnabled = true
                textField5.becomeFirstResponder()
            case textField5:
                textField5.isUserInteractionEnabled = false
                textField6.isUserInteractionEnabled = true
                textField6.becomeFirstResponder()
            case textField6:
                textField6.resignFirstResponder()
            default:
                break
            }
        }
    }
}

/* MARK:- Extensions */
extension OtpVC{
    func setupLayout(){
        btnVerify.layer.cornerRadius = 5.0
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        textField1.isUserInteractionEnabled = true
        textField2.isUserInteractionEnabled = false
        textField3.isUserInteractionEnabled = false
        textField4.isUserInteractionEnabled = false
        textField5.isUserInteractionEnabled = false
        textField6.isUserInteractionEnabled = false
        textField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField5.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField6.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    func setupTapGesture(){
        lblResend.isUserInteractionEnabled = true
        lblResend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendOtp)))
    }
    @objc func resendOtp(_ tap: UITapGestureRecognizer) {
        
    }
    func isValid() -> Bool{
        if textField1.text == "" || textField2.text == "" || textField3.text == "" || textField4.text == "" || textField5.text == "" || textField6.text == ""{
            ShowErrorAlert(message: "Please enter the OTP.")
            return false
        }
        return true
    }
    func verifyOTP(Otp: String, id: String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["OTP"]   = Otp
        parameters["Id"]    = id
        
        NetworkManager.sharedInstance.verifyOtp(Otp: Otp, id: id, param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            self.PushViewWithStoryBoard(name: ViewControllerName.Names.updatePassword, StoryBoard: Storyboard.Ids.main)
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
//                print("Something went wrong")
            }
        }
    }
}
