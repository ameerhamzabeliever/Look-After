//
//  HelpRequestCell.swift
//  MobileApp
//
//  Created by TecSpine on 22/09/2021.
//

import UIKit

class HelpRequestCell: UITableViewCell {

    @IBOutlet weak var nameLbl  : UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var requestView: UIView!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designLay()
    }
    func designLay(){
        userImage.layer.cornerRadius = userImage.frame.height/2
        acceptBtn.layer.cornerRadius = 8
        rejectBtn.layer.cornerRadius = 8
        requestView.layer.cornerRadius = 10
    }
}
