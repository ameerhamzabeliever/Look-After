//
//  MyRequsetVC.swift
//  MobileApp
//
//  Created by TecSpine on 10/12/2021.
//

import Foundation
import UIKit
import SwiftyJSON
import DropDown

class MyRequestVC: BaseVC {
    
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var myRequestTbl    : UITableView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var lblEmptyRequests : UILabel!
    
    var allRequests : [HelpRequestModel] = []
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRequestTbl.delegate   = self
        myRequestTbl.dataSource = self
        myRequestTbl.tableFooterView = UIView()
        self.myRequestTbl.register(UINib.init(nibName: XIB.Names.myRequest, bundle: nil), forCellReuseIdentifier: XIB.Names.myRequest)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLayoutsAndData()
        getHelpRequest(userId: DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID ?? "")
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapShare(_ sender : UIButton){
        if IS_DYNAMIC_LINK_CREATED{
            shareUrl(inviteLink: DYNAMIC_LINK)
        }else{
            NotificationCenter.default.post(name: .createDynamicLink, object: nil)
        }
    }
}


extension MyRequestVC {
    
    func getHelpRequest(userId: String) {
        self.allRequests.removeAll()
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
                            print(apiData)
                            self.allRequests = apiData.arrayValue.map({HelpRequestModel(json: $0)})
                            print(self.allRequests)
                            self.allRequests.reverse()
                            self.myRequestTbl.reloadData()
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
    func deleteRequest(requestId: String) {
        self.showLoading()
        var parameters : [String: Any] = [:]
        parameters["RequestId"]   = requestId
        NetworkManager.sharedInstance.deleteRequest(requestId: requestId, param: parameters){
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
    
    @IBAction func didTapMore(_ sender : UIButton){
        let index = sender.tag
        let requestId = allRequests[index].helpReqId!
        dropDown.dataSource = ["Delete"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: -20, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (selectedIndex: Int, item: String) in
            if selectedIndex == 0 {
                print("Delete Tapped")
                self?.deleteRequest(requestId: "\(requestId)")
            }
            guard let _ = self else { return }}
    }
    func setLayoutsAndData(){
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
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

/* MARK:- TableView Delegates and DataSources */
extension MyRequestVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allRequests.count == 0{
            lblEmptyRequests.alpha = 1.0
        }
        else{
            lblEmptyRequests.alpha = 0.0
        }
        return allRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myrequest = tableView.dequeueReusableCell(withIdentifier: CellIndentifier.Names.myRequest, for: indexPath) as! MyRequestCell
        let filterData = allRequests[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let startdate = dateFormatter.date(from:filterData.startingDate!)
        let endDate = dateFormatter.date(from: filterData.endingDate!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let reqDate = dateFormatter.string(from: startdate!)
        dateFormatter.dateFormat = "HH:mm"
        let startTime = dateFormatter.string(from: startdate!)
        let endTime = dateFormatter.string(from: endDate!)
        myrequest.lblDescription.text = filterData.description
        myrequest.lblDate.text = reqDate
        myrequest.lblFromTime.text = startTime
        myrequest.lblToDate.text = endTime
        myrequest.statusName.text = filterData.statusName
        myrequest.btnMenu.tag = indexPath.row
        myrequest.btnMenu.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        return myrequest
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
