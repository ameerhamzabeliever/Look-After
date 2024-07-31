//
//  DrawerVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/28/21.
//

import Foundation
import UIKit
class DrawerVC: UIViewController {
    struct MenuItems {
        let title:String
        let storyBoardID:String?
        let image: UIImage!
    }
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var namelbl      : UILabel!
    @IBOutlet weak var menuTable    : UITableView!
    
    public var callback:SideMenuCallback?
    let arrMenu: [MenuItems] =
        [MenuItems(title: "Home", storyBoardID: "", image: #imageLiteral(resourceName: "homeMenu")),
         MenuItems(title: "Calender", storyBoardID: "", image: #imageLiteral(resourceName: "calender_menu")),
         MenuItems(title: "Requests", storyBoardID: "", image: #imageLiteral(resourceName: "requestMenu")),
         MenuItems(title: "Friend Request", storyBoardID: "", image: #imageLiteral(resourceName: "friend_menu")),
         MenuItems(title: "Logout", storyBoardID: "", image: #imageLiteral(resourceName: "logout"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        setData()
        navigationController?.navigationBar.isHidden = true
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.tableFooterView = UIView()
    }
}



extension DrawerVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = menuTable.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath) as! SideMenuCell
    cell.sideMenuLabel.text = arrMenu[indexPath.row].title
    cell.sideMenuImage.image = arrMenu[indexPath.row].image
    return cell
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: false)
//
    if tableView == menuTable{
        print(indexPath.row)
        if indexPath.row == 0{
            dismiss(animated: true, completion: {
                        self.callback!.clicked(controller:"Home")
                    })
        }
        if indexPath.row == 1{
            dismiss(animated: true, completion: {
                        self.callback!.clicked(controller:"Calender")
                    })
        }
        if indexPath.row == 2{
            dismiss(animated: true, completion: {
                        self.callback!.clicked(controller:"Requests")
                    })
        }
        if indexPath.row == 3{
            dismiss(animated: true, completion: {
                        self.callback!.clicked(controller:"Friend Request")
                    })
        }
        if indexPath.row == 4{
            dismiss(animated: true, completion: {
                        self.callback!.clicked(controller:"Logout")
                    })
        }
    }
//    let menuItem = arrMenu
//
//    if menuItem.title == "Home" {
//        dismiss(animated: true, completion: {
//            self.callback!.clicked(controller:"Home")
//        })
//    }
//    else if menuItem.title == "Calender" {
// //       loginAlert()
//        dismiss(animated: true, completion: {
//            self.callback!.clicked(controller:"Orders")
//        })
//    }
//    else if menuItem.title == "Request"{
//        dismiss(animated: true, completion: {
//            self.callback!.clicked(controller:"Stores")
//        })
//    }
//    else if menuItem.title == "Friend Request" {
//        //loginAlert()
//        dismiss(animated: true, completion: {
//            self.callback!.clicked(controller:"Account")
//        })
//
//    }
//    else if menuItem.title == "Logout" {
//        dismiss(animated: true, completion: {
//            self.callback!.clicked(controller:"Products")
//        })
//    }
//
//    else{
//        if let _ = menuItem.storyBoardID {
//            if UserDefaults.standard.object(forKey: "token") != nil
//                && UserDefaults.standard.object(forKey: "email") != nil {
//               // self.logoutAccount()
//            } else {
//              //  self.loginAlert()
//            }
//
////        }
//    }
//}
//    tableView.deselectRow(at: indexPath, animated: true)
//
}
}

/* MARK:- Extension */
extension DrawerVC{
    func setLayouts(){
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
    }
    func setData(){
        if let user = DataManager.sharedInstance.getPermanentlySavedUser(){
            namelbl.text = user.FirstName
            Helper.setImage(imageView: profileImage, imageUrl: user.ProfilePicture)
        }
    }
}
