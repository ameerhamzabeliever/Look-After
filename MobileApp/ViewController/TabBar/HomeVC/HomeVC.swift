//
//  HomeVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/20/21.
//

import UIKit
import SideMenu
import SwiftyJSON
import Firebase
import DropDown
import StoreKit
import Kingfisher

class HomeVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var sideBarButton     : UIButton!
    @IBOutlet weak var postTblView       : UITableView!
    @IBOutlet weak var profileImageClick : UIImageView!
    @IBOutlet weak var lblEmptyActivity  : UILabel!
    
    let dropDown = DropDown()
    var currentDateAndTime = ""
    
    var allActivities : [ActivityModel] = []
    var menu : SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTblView.delegate   = self
        postTblView.dataSource = self
        registerNibs()
        designLayoutSideButton()
        setupTapGesture()
        setupSideMenu()
        defineDynamicLink()
    }
    override func viewWillAppear(_ animated: Bool) {
        activities()
        setLayoutsAndData()
    }
}

// Side Menu
extension HomeVC {
    private func setupSideMenu() {
        let storyboard = UIStoryboard.init(name: "Home", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DrawerVC") as? DrawerVC {
            vc.callback=self
            menu = SideMenuNavigationController(rootViewController: vc)
            menu?.settings = makeSettings()
            menu?.leftSide = true
            SideMenuManager.default.leftMenuNavigationController =  menu
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        }
    }
    private func makeSettings() -> SideMenuSettings {
        var presentationStyle = SideMenuPresentationStyle()
        presentationStyle = .viewSlideOutMenuIn
        presentationStyle.backgroundColor = .clear
        presentationStyle.onTopShadowOpacity = 0.5
        presentationStyle.onTopShadowRadius = 5
        presentationStyle.onTopShadowColor = .black
        presentationStyle.menuOnTop = true
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = 300//traitCollection.isIphone ? view.bounds.width - 60 : 350
        return settings
    }
}
extension HomeVC: SideMenuCallback{
    func clicked(controller: String) {
        if controller == "Home"{
            goToHome()
        } else if controller == "Calender"{
            goToCalender()
        } else if controller == "Requests"{
            goToReq()
        } else if controller == "Friend Request" {
            goToFR()
        }  else if controller == "Logout"{
            logoutUser()
        }
    }
    func goToHome() {
        self.tabBarController?.selectedIndex=0
    }
    func goToCalender() {
        self.tabBarController?.selectedIndex=1
    }
    func goToReq() {
        self.tabBarController?.selectedIndex=2
    }
    func goToFR() {
        self.tabBarController?.selectedIndex=3
    }
    func logoutUser(){
        COME_FROM_LINK = false
        DataManager.sharedInstance.user = nil
        DataManager.sharedInstance.getPermanentlySavedUser()?.UserID = ""
        DataManager.sharedInstance.getPermanentlySavedUser()?.Email = ""
        DataManager.sharedInstance.getPermanentlySavedUser()?.FirstName = ""
        DataManager.sharedInstance.getPermanentlySavedUser()?.LastName = ""
        DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID = ""
        DataManager.sharedInstance.getPermanentlySavedUser()?.ProfilePicture = ""
        if let viewControllers = self.navigationController?.viewControllers {
            var vcNotFound                    = true
            for vc in viewControllers {
                if vc.isKind(of: LoginViewController.self) {
                    vcNotFound = false
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            if vcNotFound {
                let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.main, bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.signIn)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
        else {
            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }

    }
}

/* MARK:- Actions */
extension HomeVC{
    @IBAction func menuButton(_ sender: UIButton) {
        setupSideMenu()
        presentModal(viewController: menu!)
    }
    @IBAction func didTapShare(_ sender : UIButton){
        if IS_DYNAMIC_LINK_CREATED{
            shareUrl(inviteLink: DYNAMIC_LINK)
        }else{
            NotificationCenter.default.post(name: .createDynamicLink, object: nil)
        }
    }
    @IBAction func didTapComment(_ sender: UIButton){
        let index = sender.tag
        let activtyId = allActivities[index].activityId
        let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.AddCommentVC) as! AddCommentVC
        vc.activity_id = "\(activtyId)"
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    @IBAction func didTapLike(_ sender : UIButton){
        let index = sender.tag
        let activtyId = allActivities[index].activityId
        let likeObj =  allActivities[index].activityLikes
        if likeObj.count != 0{
            for index in 0..<likeObj.count{
                if likeObj[index].likedUserId == DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID{
                    print("do nothing")
                    unlikeActivity(userId: DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID, activityId: "\(activtyId)")
                }else{
                    likeActivity(userId: DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID, activityId: "\(activtyId)")
                }
            }
        }
        else{
            likeActivity(userId: DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID, activityId: "\(activtyId)")
        }
    }
    @IBAction func didTapMore(_ sender : UIButton){
        let index = sender.tag
        let activityId = allActivities[index].activityId
        let user_Id = DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID
        if user_Id == allActivities[index].postedUserId {
            dropDown.dataSource = ["Delete"]
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: -20, y: sender.frame.size.height)
            dropDown.show()
            dropDown.selectionAction = { [weak self] (selectedIndex: Int, item: String) in
                if selectedIndex == 0 {
                    print("Delete Tapped")
                    self?.deleteActivity(id: "\(activityId)")
                }
                guard let _ = self else { return }}
        }
        else{
            dropDown.dataSource = ["More"]
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: -20, y: sender.frame.size.height)
            dropDown.show()
            dropDown.selectionAction = { [weak self] (selectedIndex: Int, item: String) in
                if selectedIndex == 0 {
                    print("More Tapped")
                }
                guard let _ = self else { return }}
        }
    }
}

/* MARK:- TableView Delegates and DataSources */
extension HomeVC: UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if allActivities.count ==  0{
                lblEmptyActivity.alpha = 1.0
            }
            else{
                lblEmptyActivity.alpha = 0.0
            }
            return allActivities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if indexPath.section == 0 {
            let createPostcell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.createPost, for: indexPath) as! PostCell
            return createPostcell
        }
        else if indexPath.section == 1{
            print(row)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let currentDate = dateFormatter.date(from: currentDateAndTime)
            let userPostCell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.post, for: indexPath) as! userPostVC
            /// assigning values
            if let url = URL(string: allActivities[row].picture) {
                userPostCell.posterImage.kf.setImage(with: url, placeholder: PLACEHOLDER_USER)
            }
            let activityDate = dateFormatter.date(from:allActivities[row].CreatedDateTime)
            let diffComponents = Calendar.current.dateComponents([.hour, .minute, .day], from: activityDate!, to: currentDate!)
            let minute = diffComponents.minute
            let hour = diffComponents.hour
            let day = diffComponents.day
            print("days: \(day) hours: \(hour) minutes: \(minute)")
            userPostCell.posterName  .text = allActivities[row].postedBy
            if day != 0{
                if day == 1{
                    userPostCell.posterTime  .text = "\(day!) day ago"
                }
                else{
                    userPostCell.posterTime  .text = "\(day!) days ago"
                }
            }else if hour != 0{
                if hour == 1{
                    userPostCell.posterTime  .text = "\(hour!) hour ago"
                }
                else{
                    userPostCell.posterTime  .text = "\(hour!) hours ago"
                }
            }else if minute != 0{
                if minute == 1{
                    userPostCell.posterTime  .text = "\(minute!) minute ago"
                }
                else{
                    userPostCell.posterTime  .text = "\(minute!) minutes ago"
                }
            }
            else{
                userPostCell.posterTime  .text = "Just now"
            }
            userPostCell.postDesc    .text = allActivities[row].description
            userPostCell.textViewDesc.text = allActivities[row].description
            userPostCell.likeCount   .text = "\(allActivities[row].likesCount)"
            userPostCell.commentCount.text = "\(allActivities[row].commentCount)"
            userPostCell.activityComments  = allActivities[row].activityComments
            userPostCell.activityLikes     = allActivities[row].activityLikes
            let likeActivityObj =  allActivities[row].activityLikes
            let commentActivityObj =  allActivities[row].activityComments
            /// setting values if already commented or liked
            userPostCell.imgLikeBtn.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            userPostCell.imgCommentBtn.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            for index in 0..<likeActivityObj.count{
                if likeActivityObj[index].likedUserId == DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID{
                    userPostCell.imgLikeBtn.tintColor = #colorLiteral(red: 0.01176470588, green: 0.5176470588, blue: 0.5490196078, alpha: 1)
                }
            }
            for index in 0..<commentActivityObj.count{
                if commentActivityObj[index].commentPostedUserId == DataManager.sharedInstance.getPermanentlySavedUser()!.AspNetUserID{
                    userPostCell.imgCommentBtn.tintColor = #colorLiteral(red: 0.01176470588, green: 0.5176470588, blue: 0.5490196078, alpha: 1)
                }
            }
            /// setting actions on buttons tap
            userPostCell.btnComment.tag = indexPath.row
            userPostCell.btnLike.tag = indexPath.row
            userPostCell.btnComment.addTarget(self,
                                              action: #selector(didTapComment),
                                              for: .touchUpInside)
            userPostCell.btnLike.addTarget(self,
                                              action: #selector(didTapLike),
                                              for: .touchUpInside)
            userPostCell.userPostButton.tag = indexPath.row
            
            userPostCell.userPostButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
            userPostCell.commentTableView.reloadData()
            return userPostCell
        }
        else{
            let commentCell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.userComment, for: indexPath) as! UserCommentsCell
            return commentCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        else{
            if allActivities[indexPath.row].activityComments.count == 0 {
                return 190
            }
            else if allActivities[indexPath.row].activityComments.count == 1 {
                return 260
            }
            else{
                return 330
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == postTblView{
            if indexPath.section == 0 {
                print(indexPath.row)
            }
            else if indexPath.section == 1{
                print(indexPath.row)
            }
        }
    }
}

/* MARK:- Api Methods */
extension HomeVC{
    @objc func getAllActivities(){
        let user_id = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
        self.showLoading()
        NetworkManager.sharedInstance.getActivities(user_id: user_id){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            if isCommentAdded{
                                isCommentAdded = false
                                self.allActivities.removeAll()
                            }
                            else if isActivityCreated{
                                isActivityCreated = false
                                self.ShowSuccessAlert(message: "Activty has been created.")
                                self.allActivities.removeAll()
                            }
                            self.allActivities = apiData.arrayValue.map({ActivityModel(json: $0)})
                            print(self.allActivities)
                            self.allActivities.reverse()
                            print(self.allActivities)
                            self.postTblView.reloadData()
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
    func deleteActivity(id : String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["ActivityId"]   = id
        NetworkManager.sharedInstance.deleteActivity(param: parameters, activityId: id){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        self.allActivities.removeAll()
                        self.getAllActivities()
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }
    }
    func likeActivity(userId : String, activityId : String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["userid"]   = userId
        parameters["ActivityId"] = activityId
        NetworkManager.sharedInstance.likeActivity(param: parameters, userId: userId, activityId: activityId){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        self.allActivities.removeAll()
                        self.getAllActivities()
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }
    }
    func unlikeActivity(userId : String, activityId : String){
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["userid"]   = userId
        parameters["ActivityId"] = activityId
        NetworkManager.sharedInstance.unlikeActivity(param: parameters, userId: userId, activityId: activityId){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        self.allActivities.removeAll()
                        self.getAllActivities()
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }
    }
}

/* MARK:- Extensions */
extension HomeVC{
    func registerNibs(){
        self.postTblView.register(UINib.init(nibName: XIB.Names.createPost, bundle: nil), forCellReuseIdentifier: CellIndentifier.Names.createPost)
        self.postTblView.register(UINib.init(nibName: XIB.Names.post, bundle: nil), forCellReuseIdentifier: CellIndentifier.Names.post)
    }
    func setLayoutsAndData(){
        profileImageClick.layer.cornerRadius = profileImageClick.bounds.height / 2
        if let user = DataManager.sharedInstance.getPermanentlySavedUser(){
            Helper.setImage(imageView: profileImageClick, imageUrl: user.ProfilePicture)
        }
        let date = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateAndTime = dateFormatter.string(from: date)
        currentDateAndTime = dateAndTime
        print(currentDateAndTime)
    }
    @objc func navigateToProfile(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.editprofileVC, StoryBoard: Storyboard.Ids.home)
    }
    func designLayoutSideButton()   {
        sideBarButton.layer.cornerRadius = sideBarButton.frame.height/2
        sideBarButton.clipsToBounds = true
    }
    func setupTapGesture(){
        profileImageClick.isUserInteractionEnabled = true
        profileImageClick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToProfile)))
    }
    @objc func createDynamicLink() {
        // TODO 1
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.villageMaker.com"
        components.path = "/invite"
        
        // TODO 2
        let itemIDQueryItem = URLQueryItem(name: "user_id", value: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)
        components.queryItems = [itemIDQueryItem]
        
        // TODO 3
        guard let linkParameter = components.url else { return }
        print("I am sharing \(linkParameter.absoluteString)")
        
        // TODO 4
        let domain = "https://villagemakerapp.page.link"
        guard let linkBuilder = DynamicLinkComponents
                .init(link: linkParameter, domainURIPrefix: domain) else {
                    return
                }
        
        // TODO 5
        // 1
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // 2
        linkBuilder.iOSParameters?.appStoreID = "1613915512"
        // 3
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "Village Maker App"
        linkBuilder.socialMetaTagParameters?.descriptionText = "Please accept the link to become my friend"
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdepositphotos.com%2Fvector-images%2Fhand-shake.html&psig=AOvVaw1PI6lG1gKSe8SctyuvgN8o&ust=1636093604874000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKiWueSJ_vMCFQAAAAAdAAAAABAK")!
        
        // TODO 6
        guard let longURL = linkBuilder.url else { return }
        print("The long dynamic link is \(longURL.absoluteString)")
        
        // TODO 7
        linkBuilder.shorten { url, warnings, error in
            if let error = error {
                print("Oh no! Got an error! \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }
            guard let url = url else { return }
            print("I have a short url to share! \(url.absoluteString)")
            
            /// here sharing the short url
            DYNAMIC_LINK = url.absoluteString
            IS_DYNAMIC_LINK_CREATED = true
            self.shareUrl(inviteLink: DYNAMIC_LINK)
        }
    }
    func shareUrl(inviteLink: String){
        // text to share
        ///TODO:- Change Text To Link
        let text = "Accept invitation\n\(inviteLink)"
        
        // set up activity view controller
        let textToShare            = [ text ]
        let activityViewController = UIActivityViewController(
            activityItems: textToShare,
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func activities(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getAllActivities),
            name: NSNotification.Name("getAllActivities"),
            object: nil)
        NotificationCenter.default.post(name: .getActivities, object: nil)
    }
    func defineDynamicLink(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(createDynamicLink),
            name: NSNotification.Name("createDynamicLink"),
            object: nil)
    }
}
