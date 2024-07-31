//
//  PostRequestVC.swift
//  MobileApp
//
//  Created by Hamza's Mac on 05/11/2021.
//

import UIKit
import SwiftyJSON

class PostRequestVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var viewBack      : UIView!
    @IBOutlet weak var viewGreenBack : UIView!
    @IBOutlet weak var viewFront     : UIView!
    @IBOutlet weak var textViewPost  : UITextView!
    @IBOutlet weak var btnPost  : UIButton!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var textFieldToTime   : UITextField!
    @IBOutlet weak var textFieldFromTime : UITextField!
    
    let timePicker  = UIDatePicker()
    var hourTime    = ""
    var minuteTime  = ""
    var requestDate = ""
    var currentDateAndTime = ""
    var senderTag : Int?
    var toTime   = Date()
    var fromTime = Date()
    var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPost.delegate = self
        textFieldToTime.delegate = self
        textFieldFromTime.delegate = self
        setLayouts()
        showDatePicker()
    }
}
/* MARK:- Actions */
extension PostRequestVC{
    @IBAction func didTapPost(_ sender : UIButton){
        let date = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateAndTime = dateFormatter.string(from: date)
        currentDateAndTime = dateAndTime
        print(currentDateAndTime)
        validateAndPost()
    }
    @IBAction func didTapClose(_ sender : UIButton){
        self.view.removeFromSuperview()
    }
}

/* MARK:- Extensions */
extension PostRequestVC : UITextViewDelegate{
    func setLayouts(){
        viewBack     .layer.cornerRadius  = 20.0
        viewFront    .layer.cornerRadius  = 20.0
        viewGreenBack.layer.cornerRadius  = 20.0
        textViewPost .layer.cornerRadius  = 20.0
        btnPost.layer.cornerRadius        = 10.0
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstTime{
            firstTime = false
            textView.text = nil
        }
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Your message"
//        }
//    }
    func showDatePicker(){
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        timePicker.preferredDatePickerStyle = .wheels
        textFieldToTime  .inputView = timePicker
        textFieldFromTime.inputView = timePicker
    }
    @objc func dateChanged(_ picker: UIDatePicker){
        print(picker.tag)
        let calendar =  Calendar.current
        let hour = calendar.component(.hour, from: picker.date)
        let minute = calendar.component(.minute, from: picker.date)
        hourTime = String(format: "%02d", hour)
        minuteTime = String(format: "%02d", minute)
        print("\(hourTime):\(minuteTime)")
        if senderTag == 0{
            let fromTimeStr = "\(hourTime):\(minuteTime)"
            fromTime = stringToTime(fromTimeStr)!
            textFieldFromTime.text = fromTimeStr
        }
        else{
            let toTimeStr = "\(hourTime):\(minuteTime)"
            toTime = stringToTime(toTimeStr)!
            if fromTime > toTime{
                ShowErrorAlert(message: "To time must be greater than from time")
                return
            }else if fromTime == toTime{
                ShowErrorAlert(message: "To time must be greater than from time")
                return
            }
            else{
                textFieldToTime.text = toTimeStr
            }
        }
    }
    func validateAndPost(){
        guard let description = textViewPost.text, description != "Your message" else{
            self.showToast(message: "Description cannot be empty")
            return
        }
        guard let description = textViewPost.text, description != "" else{
            self.showToast(message: "Description cannot be empty")
            return
        }
        guard let fromText = textFieldFromTime.text, fromText != "" else{
            self.showToast(message: "From time cannot be empty")
            return
        }
        guard let toText = textFieldToTime.text, toText != "" else{
            self.showToast(message: "To time cannot be empty")
            return
        }
        postRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID,
                    description: description,
                    createdDate: currentDateAndTime,
                    startedDate: "\(requestDate)T\(fromText):00",
                    endingDate: "\(requestDate)T\(toText):00",
                    status: 1)
    }
    func postRequest(userId: String, description: String, createdDate: String, startedDate: String, endingDate: String, status : Int){
        self.showLoading()
        var parameters : [String: Any] = [:]
        
        parameters["CreateUserId"] = userId
        parameters["Description"]  = description
        parameters["CreatedDate"]  = createdDate
        parameters["StartingDate"] = startedDate
        parameters["EndingDate"]   = endingDate
        parameters["Status"]       = status
        NetworkManager.sharedInstance.createRequest(param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        self.view.removeFromSuperview()
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }
    }
    func stringToTime(_ time: String) -> Date? {
        let formatter        = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time)
    }
}

/* MARK:- TextField Delegate */
extension PostRequestVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case textFieldFromTime:
            senderTag = 0
        case textFieldToTime:
            senderTag = 1
            if textFieldFromTime.text == ""{
                ShowErrorAlert(message: "Please select a from time first.")
                textFieldToTime.resignFirstResponder()
            }
        default:
            break
        }
    }
}
