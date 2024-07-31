//
//  PostCell.swift
//  MobileApp
//
//  Created by TecSpine on 9/20/21.
//

import UIKit
import SwiftyJSON

class PostCell: UITableViewCell, UITextViewDelegate {
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var mainViewPostCell : UIView!
    @IBOutlet weak var textViewPost     : UITextView!
    @IBOutlet weak var postButton       : UIButton!
    
    var desc = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewPost.delegate = self
        buttonDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func buttonDesign(){
        postButton.layer.cornerRadius = postButton.frame.height/2
        postButton.clipsToBounds = true
        postButton.imageView?.tintColor = UIColor.white
        mainViewPostCell.layer.cornerRadius = 12
    }
    @IBAction func didTapPost(_ sender: UIButton){
        desc = textViewPost.text
        if desc == "Message the people who have your best interest at heart..." || desc == ""{
            showToast(message: "Please enter message.")
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
            print(currentDateAndTime)
            createActivity(dateAndTime: currentDateAndTime)
        }
    }
    func createActivity(dateAndTime : String){
//        self.showLoading()
        var parameters : [String: Any] = [:]
        let user_id     = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
        let dateTime    = dateAndTime
        let description = desc
        
        parameters["UserId"]      = user_id
        parameters["DateTime"]    = dateTime
        parameters["description"] = description
        print(parameters)
        NetworkManager.sharedInstance.createActivity(
            param        : parameters,
            user_id      : user_id,
            dateTime     : dateTime,
            activity_desc: description
        ){
            (response) in
//            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        isActivityCreated = true
                        self.textViewPost.textColor = .systemGray2
                        self.textViewPost.text = "Message the people who have your best interest at heart..."
                        NotificationCenter.default.post(name: .getActivities, object: nil)
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            case .failure(_):
                print("Something went wrong")
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message the people who have your best interest at heart..."{
            textView.text = nil
        }
            textView.textColor = .black
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray2
            textView.text = "Message the people who have your best interest at heart..."
        }
    }
}
