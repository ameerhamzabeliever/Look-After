//
//  MyRequestCell.swift
//  MobileApp
//
//  Created by Hamza's Mac on 28/12/2021.
//

import UIKit

class MyRequestCell: UITableViewCell {
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var imgRequestPoster : UIImageView!
    @IBOutlet weak var lblDescription   : UILabel!
    @IBOutlet weak var statusName       : UILabel!
    @IBOutlet weak var viewStatus       : UIView!
    @IBOutlet weak var viewDate         : UIView!
    @IBOutlet weak var viewFrom         : UIView!
    @IBOutlet weak var viewTo           : UIView!
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblFromTime      : UILabel!
    @IBOutlet weak var lblToDate        : UILabel!
    @IBOutlet weak var viewBack         : UIView!
    @IBOutlet weak var btnMenu          : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    func setupLayout(){
        btnMenu.layer.cornerRadius    = btnMenu.frame.height/2
        viewStatus.layer.cornerRadius = 3.0
        viewDate.layer.cornerRadius   = 2.0
        viewFrom.layer.cornerRadius   = 2.0
        viewTo.layer.cornerRadius     = 2.0
        viewBack.layer.cornerRadius   = 15.0
    }
}
