//
//  FirendRequestCell.swift
//  MobileApp
//
//  Created by TecSpine on 10/31/21.
//

import UIKit

class FirendRequestCell: UITableViewCell {
    @IBOutlet weak var userNameLbl     : UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var friendRequestLbl: UILabel!
    @IBOutlet weak var acceptBtnOutlet : UIButton!
    @IBOutlet weak var rejectBtnOutlet : UIButton!
    @IBOutlet weak var friendView      : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designLay()
    }
    func designLay()
    {
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2
        acceptBtnOutlet.layer.cornerRadius  = 8
        rejectBtnOutlet.layer.cornerRadius  = 8
        friendView.layer.cornerRadius       = 10
    }
}
