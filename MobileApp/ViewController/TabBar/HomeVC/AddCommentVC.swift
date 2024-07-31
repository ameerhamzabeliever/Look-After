//
//  AddCommentVC.swift
//  MobileApp
//
//  Created by Hamza's Mac on 09/11/2021.
//

import UIKit
import SwiftyJSON

class AddCommentVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var viewContent     : UIView!
    @IBOutlet weak var viewGreenBack   : UIView!
    @IBOutlet weak var viewFront       : UIView!
    @IBOutlet weak var textViewComment : UITextView!
    @IBOutlet weak var btnPost         : UIButton!
    @IBOutlet weak var btnClose        : UIButton!
    
    var activity_id = ""
    var commentDesc = ""
    var user_id = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewComment.delegate = self
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        setLayouts()
    }
    
    func setLayouts(){
        viewContent    .layer.cornerRadius = 20.0
        viewGreenBack  .layer.cornerRadius = 20.0
        viewFront      .layer.cornerRadius = 20.0
        textViewComment.layer.cornerRadius = 20.0
        btnPost        .layer.cornerRadius = 10.0
    }
}

/* MARK:- Actions */
extension AddCommentVC{
    @IBAction func didTapPost(){
        commentDesc = textViewComment.text
        if commentDesc == "Leave a comment here" || commentDesc == ""{
            self.ShowErrorAlert(message: "Please enter a comment")
        }
        else{
            /// calculate current time and date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let result = formatter.string(from: date)
            let currentDate = result
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let currentDateAndTime = "\(currentDate) \(hour):\(minutes)"
            createComment(activityId: activity_id, comment: commentDesc, userId: user_id, dateTime: currentDateAndTime)
        }
    }
    @IBAction func didTapClose(_ sender : UIButton){
        self.view.removeFromSuperview()
    }
}

/* MARK:- UITextViewDelegate */
extension AddCommentVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray2
            textView.text = "Leave a comment here"
        }
    }
}

/* MARK:- Extension */
extension AddCommentVC{
    func createComment(activityId: String,
                       comment: String,
                       userId: String,
                       dateTime: String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        
        parameters["ActivityId"]   = activityId
        parameters["Comment"]    = comment
        parameters["UserId"] = userId
        parameters["CreatingDateTime"] = dateTime
        print(parameters)
        NetworkManager.sharedInstance.addComment(param: parameters, activity: activityId, comment_Desc: comment, user_Id: userId, creationDateTime: dateTime){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        isCommentAdded = true
                        NotificationCenter.default.post(name: .getActivities, object: nil)
                        self.view.removeFromSuperview()
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            self.view.removeFromSuperview()
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
