//
//  FriendRequestVC.swift
//  MobileApp
//
//  Created by TecSpine on 22/09/2021.
//

import UIKit
import SideMenu
import SwiftyJSON
import Kingfisher

class FriendRequestVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var sideBarButton     : UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var friendRequestTbl: UITableView!
    @IBOutlet weak var noFriendsLbl    : UILabel!
    
    var menu : SideMenuNavigationController?
    var allFriends : [FriendModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designLay()
        addFriend()
        friendRequestTbl.delegate = self
        friendRequestTbl.dataSource = self
        friendRequestTbl.tableFooterView = UIView()
        
        self.friendRequestTbl.register(UINib.init(nibName: XIB.Names.friendRequest, bundle: nil), forCellReuseIdentifier: XIB.Names.friendRequest)
        setupTapGesture()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getFriends()
        setData()
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

    func designLay()
    {
        sideBarButton.layer.cornerRadius = sideBarButton.frame.height/2
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        sideBarButton.clipsToBounds = true
    }
    func setData(){
        if let user = DataManager.sharedInstance.getPermanentlySavedUser(){
            Helper.setImage(imageView: profilePictureView, imageUrl: user.ProfilePicture)
        }
    }
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
    func setupTapGesture(){
        profilePictureView.isUserInteractionEnabled = true
        profilePictureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToProfile)))
        
    }
    @objc func navigateToProfile(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.editprofileVC, StoryBoard: Storyboard.Ids.home)
    }
}

extension FriendRequestVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allFriends.count == 0{
            self.noFriendsLbl.alpha = 1.0
        }
        else{
            self.noFriendsLbl.alpha = 0.0
        }
        return allFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendcell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.friendRequest, for: indexPath) as! FirendRequestCell
        if let url = URL(string: allFriends[indexPath.row].friendPhoto) {
            friendcell.userProfileImage.kf.setImage(with: url, placeholder: PLACEHOLDER_USER)
        }
        friendcell.userNameLbl.text = allFriends[indexPath.row].friendName
        friendcell.friendRequestLbl.text = "you and \(allFriends[indexPath.row].friendName) are friends."
        friendcell.rejectBtnOutlet.tag = indexPath.row
        friendcell.rejectBtnOutlet.addTarget(self,
                                        action:  #selector(didTapReject),
                                        for: .touchUpInside)
        return friendcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension FriendRequestVC: SideMenuCallback{
    func clicked(controller: String) {
        if controller == "Home"{
            goToHome()
        } else if controller == "Calender"{
            goToCalender()
        } else if controller == "Requests"{
            goToReq()
        } else if controller == "Friend Request" {
            goToFR()
        } else if controller == "Logout"{
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

/* MARK:-  Actions */
extension FriendRequestVC{
    @IBAction func didTapReject(_ sender: UIButton){
        let index = sender.tag
        let friendId = allFriends[index].friendUserId
        removeFriend(friendId: friendId)
    }
    @IBAction func sideBarButtonPressed(_ sender: UIButton) {
        setupSideMenu()
        presentModal(viewController: menu!)
    }
    @IBAction func didTapShare(_ sender: UIButton){
        if IS_DYNAMIC_LINK_CREATED{
            shareUrl(inviteLink: DYNAMIC_LINK)
        }else{
            NotificationCenter.default.post(name: .createDynamicLink, object: nil)
        }
    }
}

/* MARK:- Extension */
extension FriendRequestVC{
    /* MARK:- API Methods */
    func addFriend(){
        if COME_FROM_LINK{
            print(USER_ID)
            let otherUserId = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
            self.showLoading()
            var parameters : [String: Any] = [:]
            
            parameters["UserId"]          = USER_ID
            parameters["FriendUserId"]    = otherUserId
            NetworkManager.sharedInstance.addFriend(
                param: parameters,
                otherUserId: otherUserId
            ){
                (response) in
                self.hideLoading()
                switch response.result{
                case .success(_):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            self.getFriends()
                        }
                    }
                    
                case .failure(_):
                    print("Something went wrong")
                }
            }
        }
    }
    func getFriends(){
        let user_id = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
        self.showLoading()
        NetworkManager.sharedInstance.getFriends(user_id: user_id){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            self.allFriends = apiData.arrayValue.map({FriendModel(json: $0)})
                            print(self.allFriends)
                            self.friendRequestTbl.reloadData()
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
    func removeFriend(friendId : String){
        let user_id = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
        self.showLoading()
        var parameters : [String: Any] = [:]
        
        parameters["UserId"]          = user_id
        parameters["FriendUserId"]    = friendId
        NetworkManager.sharedInstance.removeFriend(param: parameters, user_id: user_id, otherUserId: friendId){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        self.getFriends()
                    }
                }
                
            case .failure(_):
                print("Something went wrong")
            }
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
}
