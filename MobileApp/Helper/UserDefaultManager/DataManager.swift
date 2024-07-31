//
//  DataManager.swift
//  MobileApp
//
//  Created by TecSpine on 15/09/2021.
//

import Foundation

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    var user: UserModel? {
        didSet {
            saveUserPermanentally()
        }
    }
    
    func logoutUser() {
        
        let newUser = UserModel.init()
        user = nil
        user = newUser
        self.saveUserPermanentally()
        
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    func saveUserPermanentally() {
        if user != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user!)
            UserDefaults.standard.set(encodedData, forKey: "user")
            
        } else {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
    func getPermanentlySavedUser() -> UserModel? {
        
        if let data = UserDefaults.standard.data(forKey: "user"),
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserModel {
            return userData
        } else {
            return UserModel.init(json: ["" : "" as AnyObject])
        }
    }
   
}
