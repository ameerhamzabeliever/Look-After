//
//  UserCommentsCell.swift
//  MobileApp
//
//  Created by TecSpine on 10/31/21.
//

import UIKit
import Kingfisher

class UserCommentsCell: UITableViewCell {

    @IBOutlet weak var commentTimeLbl  : UILabel!
    @IBOutlet weak var commentImage    : UIImageView!
    @IBOutlet weak var commentLbl      : UILabel!
    @IBOutlet weak var commentNameTitle: UILabel!
    @IBOutlet weak var userCommentView : UIView!
    @IBOutlet weak var viewContent     : UIView!
    @IBOutlet weak var btnMore         : UIButton!
    
    var currentDate = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designLay()
        setData()
    }
    func designLay(){
        commentImage.layer.cornerRadius = commentImage.frame.height/2
        userCommentView.layer.cornerRadius = 8
        viewContent.layer.cornerRadius = 12.0
        btnMore.layer.cornerRadius = btnMore.frame.height / 2
    }
    func setData(){
        let date = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateAndTime = dateFormatter.string(from: date)
        currentDate = dateAndTime
        print(currentDate)
    }
    func setCommentData(comment : ActivityCommentsModel){
        print(comment)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let url = URL(string: comment.profilePicture) {
            commentImage.kf.setImage(with: url, placeholder: PLACEHOLDER_USER)
        }
        let currentDateAndTime = dateFormatter.date(from: currentDate)
        let commentDate = dateFormatter.date(from: comment.CreatedDateTime)
        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .day], from: commentDate!, to: currentDateAndTime!)
        let minute = diffComponents.minute
        let hour = diffComponents.hour
        let day = diffComponents.day
        print("days: \(day) hours: \(hour) minutes: \(minute)")
        commentNameTitle.text = comment.commentPostedBy
        commentLbl.text = comment.comment_Desc
        if day != 0{
            if day == 1{
                commentTimeLbl.text = "\(day!) day ago"
            }
            else{
                commentTimeLbl.text = "\(day!) days ago"
            }
        }else if hour != 0{
            if hour == 1{
                commentTimeLbl.text = "\(hour!) hour ago"
            }
            else{
                commentTimeLbl.text = "\(hour!) hours ago"
            }
        }else if minute != 0{
            if minute == 1{
                commentTimeLbl.text = "\(minute!) minute ago"
            }
            else{
                commentTimeLbl.text = "\(minute!) minutes ago"
            }
        }
        else{
            commentTimeLbl.text = "Just now"
        }
    }
}
