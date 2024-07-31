//
//  HelpRequestVC.swift
//  MobileApp
//
//  Created by TecSpine on 22/09/2021.
//

import UIKit
import SideMenu
import SwiftyJSON
import Kingfisher

class HelpRequestVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var sideBarButton     : UIButton!
    @IBOutlet weak var helpRequestTbl    : UITableView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var lblEmptyRequests  : UILabel!
    
    var menu : SideMenuNavigationController?
    
    var helpRequestList: [HelpRequestModel] = []
    var filterhelpRequest: [HelpRequestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designLay()
        helpRequestTbl.delegate   = self
        helpRequestTbl.dataSource = self
        helpRequestTbl.tableFooterView = UIView()
        self.helpRequestTbl.register(UINib.init(nibName: XIB.Names.helpRequest, bundle: nil), forCellReuseIdentifier: XIB.Names.helpRequest)
        setupTapGesture()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setData()
        getHelpRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID ?? "")
    }
}

/* MARK:- Actions */
extension HelpRequestVC{
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
    @IBAction func didTapAccept(_ sender: UIButton){
        let index = sender.tag
        let requestId = helpRequestList[index].helpReqId!
        let acceptUserId = (DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID)!
        acceptRequest(requestId: "\(requestId)", userId: acceptUserId)
    }
}

extension HelpRequestVC {
    func getHelpRequest(userId: String) {
        self.helpRequestList.removeAll()
        self.showLoading()
        NetworkManager.sharedInstance.getUserFriendsHelpRequests(user_id: userId){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            self.helpRequestList.removeAll()
                            self.filterhelpRequest.removeAll()
                            self.helpRequestList = apiData.arrayValue.map({HelpRequestModel(json: $0)})
                            for index in 0..<self.helpRequestList.count{
                                if self.helpRequestList[index].createUserID != DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID{
                                    self.filterhelpRequest.append(self.helpRequestList[index])
                                }
                            }
                            self.helpRequestList = self.filterhelpRequest
                            print(self.helpRequestList)
                            self.helpRequestTbl.reloadData()
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
    
    func acceptRequest(requestId: String, userId : String) {
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["RequestId"]   = requestId
        parameters["AcceptUserId"]   = userId
        NetworkManager.sharedInstance.acceptRequest(requestId: requestId, userId: userId, param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            self.getHelpRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID ?? "")
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

/* MARK:- TableView Delegates and DataSources */
extension HelpRequestVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if helpRequestList.count == 0{
            lblEmptyRequests.alpha = 1.0
        }
        else{
            lblEmptyRequests.alpha = 0.0
        }
        return helpRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helpCell = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.helpRequest, for: indexPath) as! HelpRequestCell
        let filterData = helpRequestList[indexPath.row]
        if let url = URL(string: filterData.photo) {
            helpCell.userImage.kf.setImage(with: url, placeholder: PLACEHOLDER_USER)
        }
        if filterData.aceptedUserID != ""{
            helpCell.acceptBtn.isHidden = true
        }
        else{
            helpCell.acceptBtn.isHidden = false
        }
        helpCell.acceptBtn.tag = indexPath.row
        helpCell.acceptBtn.addTarget(self,
                                        action:  #selector(didTapAccept),
                                        for: .touchUpInside)
        helpCell.nameLbl.text = filterData.helpRequestCreaterUserName
        let availabiltyDate = Helper.utcToLocalDate(dateStr: filterData.createdDate ?? "")
        let availabiltyTime = Helper.utcToLocalTime(dateStr: filterData.createdDate ?? "")
        let desc = "\(filterData.description ?? ""). Is anyone available on \(availabiltyDate ?? "") at \(availabiltyTime ?? "")?"
        print(desc)
        helpCell.detailLbl.text = desc
        return helpCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension HelpRequestVC: SideMenuCallback{
    
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

/* MARK:- Extension */
extension HelpRequestVC{
    func setupTapGesture(){
        profilePictureView.isUserInteractionEnabled = true
        profilePictureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToProfile)))
        
    }
    @objc func navigateToProfile(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.editprofileVC, StoryBoard: Storyboard.Ids.home)
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
