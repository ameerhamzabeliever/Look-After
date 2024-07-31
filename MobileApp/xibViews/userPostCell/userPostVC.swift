//
//  userPostVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/20/21.
//

import UIKit

class userPostVC: UITableViewCell{
    
    /* Outlets and Properties */
    @IBOutlet weak var userPostView   : UIView!
    @IBOutlet weak var posterName     : UILabel!
    @IBOutlet weak var posterTime     : UILabel!
    @IBOutlet weak var postDesc       : UILabel!
    @IBOutlet weak var likeLabel      : UILabel!
    @IBOutlet weak var commentLable   : UILabel!
    @IBOutlet weak var likeCount         : UILabel!
    @IBOutlet weak var posterImage    : UIImageView!
    @IBOutlet weak var likeCountImage : UIImageView!
    @IBOutlet weak var commentCountImage : UIImageView!
    @IBOutlet weak var commentCount      : UILabel!
    @IBOutlet weak var userPostButton    : UIButton!
    @IBOutlet weak var btnComment        : UIButton!
    @IBOutlet weak var imgCommentBtn     : UIImageView!
    @IBOutlet weak var btnLike           : UIButton!
    @IBOutlet weak var imgLikeBtn     : UIImageView!
    @IBOutlet weak var commentTableView  : UITableView!
    @IBOutlet weak var textViewDesc : UITextView!
    @IBOutlet weak var textLblDesc : UILabel!
    
    var activityComments : [ActivityCommentsModel] = []
    var activityLikes    : [ActivityLikesModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTableView()
        userButtonDesign()
    }
    func setupTableView(){
        commentTableView.dataSource = self
        commentTableView.delegate   = self
        commentTableView.isScrollEnabled = true
        commentTableView.isHidden = false
        self.commentTableView.register(UINib.init(nibName: XIB.Names.userComment, bundle: nil), forCellReuseIdentifier: CellIndentifier.Names.userComment)
    }
    func userButtonDesign() {
        btnComment.titleLabel?.text = ""
        posterImage.layer.cornerRadius = posterImage.frame.height/2
        userPostButton.layer.cornerRadius = userPostButton.frame.height/2
        userPostButton.clipsToBounds = true
        userPostView.layer.cornerRadius = 12
        contentView.layer.cornerRadius = 8
        
    }
}

/* MARK:- Extension */
extension userPostVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCommentcell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.userComment, for: indexPath) as! UserCommentsCell
        if activityComments.count != 0{
            print(indexPath.row)
                userCommentcell.setCommentData(comment: activityComments[indexPath.row])
        }
        return userCommentcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if tableView == commentTableView{
            print(row)
        }
    }
}
