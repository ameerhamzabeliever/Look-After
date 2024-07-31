//
//  CalendarVC.swift
//  MobileApp
//
//  Created by TecSpine on 10/5/21.
//

import Foundation
import FSCalendar
import UIKit
import SideMenu
import SwiftyJSON

class CalendarVC: BaseVC, FSCalendarDelegate
{
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var stackCalendar: UIStackView!
    @IBOutlet weak var addRequestView: UIView!
    @IBOutlet weak var yourRequestView: UIView!
    @IBOutlet weak var helpRequestView: UIView!
    @IBOutlet weak var otherRequestView: UIView!
    @IBOutlet weak var yourReqLbl: UILabel!
    @IBOutlet weak var yourReqVal: UILabel!
    @IBOutlet weak var helpReqLabl: UILabel!
    @IBOutlet weak var helpReqVal: UILabel!
    @IBOutlet weak var otherReqLbl: UILabel!
    @IBOutlet weak var otherReqVal: UILabel!
    
    var menu : SideMenuNavigationController?
    var requestDate = ""
    var currentDate = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        designLayout()
        setupTapGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        setData()
        calculateCurrentDate()
        getMyHelpRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID ?? "")
        getFriendsHelpRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID ?? "")
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
}
extension CalendarVC: SideMenuCallback{
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

/* MARK:- Actions */
extension CalendarVC{
    @IBAction func nextTapped(_ sender : UIButton) {
        calendarView.setCurrentPage(getNextMonth(date: calendarView.currentPage), animated: true)
    }
    @IBAction  func previousTapped(_ sender : UIButton) {
        calendarView.setCurrentPage(getPreviousMonth(date: calendarView.currentPage), animated: true)
    }
    @IBAction func sideBarButtonPressed(_ sender: UIButton) {
        setupSideMenu()
        presentModal(viewController: menu!)
    }
    @IBAction func didTapAddRequest(_ sender : UIButton){
        if requestDate != ""{
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.postRequest) as! PostRequestVC
            vc.requestDate = requestDate
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        else{
            self.ShowErrorAlert(message: "Please select a valid date to create help request.")
        }
    }
    @IBAction func didTapShare(_ sender : UIButton){
        if IS_DYNAMIC_LINK_CREATED{
            shareUrl(inviteLink: DYNAMIC_LINK)
        }else{
            NotificationCenter.default.post(name: .createDynamicLink, object: nil)
        }
    }
}

/* MARK:- Extension */
extension CalendarVC{
    func setupTapGesture(){
        titleImage.isUserInteractionEnabled = true
        titleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToProfile)))
        
        yourRequestView.isUserInteractionEnabled = true
        yourRequestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToMyRequest)))
        helpRequestView.isUserInteractionEnabled = true
        helpRequestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToHelpRequest)))
        
    }
    @objc func navigateToMyRequest(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.myRequest, StoryBoard: Storyboard.Ids.home)
    }
    @objc func navigateToHelpRequest(_ tap: UITapGestureRecognizer) {
        self.tabBarController?.selectedIndex=2
    }
    @objc func navigateToProfile(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: ViewControllerName.Names.editprofileVC, StoryBoard: Storyboard.Ids.home)
    }
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: date)
        print("Date",date)
        let currentDateObj = formatter.date(from: currentDate)
        let requestDateObj = formatter.date(from: date)
        if requestDateObj?.compare(currentDateObj!) == .orderedAscending || requestDateObj?.compare(currentDateObj!) == .orderedSame{
            requestDate = ""
            self.ShowErrorAlert(message: "Please select a valid date.")
        }
        else{
            requestDate = date
        }
    }
    func designLayout(){
        otherRequestView.isHidden = true
        menuButton.layer.cornerRadius = menuButton.frame.height/2
        menuButton.clipsToBounds = true
        calendarView.layer.cornerRadius = 10
        stackCalendar.layer.cornerRadius = 10
        addRequestView.layer.cornerRadius = 10
        yourRequestView.layer.cornerRadius = 10
        helpRequestView.layer.cornerRadius = 10
        otherRequestView.layer.cornerRadius = 10
        titleImage.layer.cornerRadius = titleImage.bounds.height / 2
    }
    func setData(){
        if let user = DataManager.sharedInstance.getPermanentlySavedUser(){
            Helper.setImage(imageView: titleImage, imageUrl: user.ProfilePicture)
        }
    }
    func calculateCurrentDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        currentDate = result
    }
    func goToPostRequestVC(){
        PushViewWithStoryBoard(name: ViewControllerName.Names.postRequest, StoryBoard: Storyboard.Ids.home)
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

extension CalendarVC{
    func getMyHelpRequest(userId: String) {
        self.showLoading()
        NetworkManager.sharedInstance.getUserRequests(user_id: userId){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let apiData = try JSON(data: response.data!)
                            print(apiData.count)
                            let myCount = apiData.count
                            self.yourReqVal.text = "\(myCount)"
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
    func getFriendsHelpRequest(userId: String) {
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
                            print(apiData.count)
                            let friendCount = apiData.count
                            self.helpReqVal.text = "\(friendCount)"
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
