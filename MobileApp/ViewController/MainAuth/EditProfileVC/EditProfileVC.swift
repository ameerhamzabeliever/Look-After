//
//  EditProfileVC.swift
//  MobileApp
//
//  Created by TecSpine on 9/28/21.
//

import Foundation
import UIKit
import YPImagePicker
import SwiftyJSON
import Kingfisher

class EditProfileVC: BaseVC
{
    /* MARK:- Outlets and Properties */
    @IBOutlet weak var backButton          : UIButton!
    @IBOutlet weak var editButton          : UIButton!
    @IBOutlet weak var saveButton          : UIButton!
    @IBOutlet weak var profileButtonOutlet : UIButton!
    @IBOutlet weak var btnUpdatePassword   : UIButton!
    @IBOutlet weak var fNameView           : UIView!
    @IBOutlet weak var lNameView           : UIView!
    @IBOutlet weak var emailView           : UIView!
    @IBOutlet weak var passwordView        : UIView!
    @IBOutlet weak var fnameTF             : UITextField!
    @IBOutlet weak var lnameTF             : UITextField!
    @IBOutlet weak var emailTF             : UITextField!
    @IBOutlet weak var passwordTF          : UITextField!
    @IBOutlet weak var showPassword        : UILabel!
    @IBOutlet weak var profileImage        : UIImageView!
    @IBOutlet weak var viewProfileImage    : UIView!
    
    var pickedPhoto      : UIImage?
    var isPhotoPicked =  false
    var updatingPassword = false
    var updatedUser : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setData()
        setupTapGesture()
    }
}

/* MARK:- Actions */
extension EditProfileVC{
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveEditing()
    }
    @IBAction func profileBrowseButtonPressed(_ sender: UIButton) {
        showPickerPhotos()
    }
    @IBAction func didTapUpdatePass(_ sender : UIButton){
        updatingPassword = true
        btnUpdatePassword.alpha = 0.0
        passwordView.alpha = 0.0
    }
    func setupTapGesture(){
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToHome)))
    }
}

/* MARK:- Extensions */
extension EditProfileVC{
    func layoutUI(){
        viewProfileImage.layer.cornerRadius = 70.0
        profileImage.layer.cornerRadius = 70.0
        backButton.layer.cornerRadius = backButton.frame.height/2
        btnUpdatePassword.layer.cornerRadius = 12.0
        backButton.clipsToBounds = true
        editButton.layer.cornerRadius = editButton.frame.height/2
        editButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 12
        fNameView.layer.cornerRadius = 10
        lNameView.layer.cornerRadius = 10
        emailView.layer.cornerRadius = 10
        passwordView.layer.cornerRadius = 10
    }
    func setData(){
        profileButtonOutlet.alpha = 1.0
        passwordView.alpha = 0.0
        btnUpdatePassword.alpha = 0.0
        if let user = DataManager.sharedInstance.getPermanentlySavedUser(){
            Helper.setImage(imageView: profileImage, imageUrl: user.ProfilePicture)
            emailTF.text = user.Email
            fnameTF.text = user.FirstName
            lnameTF.text = user.LastName
        }
    }
    func isValid() -> Bool {
        guard let name  = self.fnameTF.text, !name.isEmpty else {
            self.ShowErrorAlert(message: MessageConstant.enterName, AlertTitle: MessageConstant.empty)
            return false
        }
        guard let lname  = self.lnameTF.text, !lname.isEmpty else {
            self.ShowErrorAlert(message: MessageConstant.enterName, AlertTitle: MessageConstant.empty)
            return false
        }
        return true
    }
    func saveEditing() {
        if isValid() {
            DataManager.sharedInstance.user?.FirstName = fnameTF.text!
            DataManager.sharedInstance.user?.LastName = lnameTF.text!
            //            DataManager.sharedInstance.user?.Password = passwordTF.text!
            if isPhotoPicked{
                isPhotoPicked = false
                uploadPhoto()
            }
            else{
                updateProfile(path: DataManager.sharedInstance.getPermanentlySavedUser()?.ProfilePicture ?? "")
            }
        }
    }
    @objc func navigateToHome(_ tap: UITapGestureRecognizer) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func showPickerPhotos(){
        var config                          = YPImagePickerConfiguration()
        config.library.mediaType            = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen                = .photo
        config.screens                      = [.library]
        config.wordings.libraryTitle        = "Photos"
        config.usesFrontCamera              = true
        config.showsPhotoFilters            = false
        config.hidesStatusBar               = false
        config.hidesBottomBar               = false
        config.library.maxNumberOfItems     = 1
        config.library.onlySquare           = false
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.pickedPhoto = photo.image
                    self.isPhotoPicked = true
                    self.profileImage.image = photo.image
                    self.profileButtonOutlet.alpha = 0.0
                    picker.dismiss(animated: true, completion: nil)
                default:
                    break
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
    func updateProfile(path : String){
        showLoading()
        var parameters : [String : String] = [:]
        parameters["FirstName"]   = fnameTF.text
        parameters["LastName"]    = lnameTF.text
        parameters["ProfilePicture"] = path
        NetworkManager.sharedInstance.updateProfile(param: parameters){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do{
                            let jsonData = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as AnyObject
                            let apiData = jsonData as! [String : AnyObject]
                            print(apiData)
                            let updateUser = UserModel(json: apiData)
                            DataManager.sharedInstance.user = updateUser
                            DataManager.sharedInstance.saveUserPermanentally()
                            self.ShowSuccessAlert(message: MessageConstant.dataSaved)
                            print(updateUser.UserID)
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
    func uploadPhoto(){
        showLoading()
        NetworkManager.sharedInstance.uploadPhoto(image: self.pickedPhoto, imageKey: "image"){
            (response) in
            self.hideLoading()
            switch response.result{
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        do {
                            let apiData = try JSON(data: response.data!)
                            print(apiData)
                            let fileName = apiData["FileNames"].arrayValue
                            let imagePath = fileName[0].stringValue
                            print(imagePath)
                            self.updateProfile(path: "/Uploads/\(imagePath)")
                        } catch let myJSONError {
                            print("api response data could not serialize ", myJSONError)
                            print(myJSONError)
                        }
                    }
                }
            case .failure(_):
                self.ShowErrorAlert(message: "Something went wrong")
            }
        }
    }
}
