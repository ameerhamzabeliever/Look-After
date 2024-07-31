//
//  AppDelegate.swift
//  MobileApp
//
//  Created by TecSpine on 9/8/21.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //    func application(
    //        _ app: UIApplication,
    //        open url: URL,
    //        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    //    ) -> Bool {
    //
    //        ApplicationDelegate.shared.application(
    //            app,
    //            open: url,
    //            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    //        )
    //    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        ///step 1 for dynamicLink
        FirebaseApp.configure()
        window?.overrideUserInterfaceStyle = .light
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        goToDirectedVC()
        
        return true
    }
    
    /// step 2 for dynamicLink
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL link is \(incomingURL)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamiclink, error) in
                guard error == nil else{
                    print("Error is \(error?.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamiclink{
                    self.handleIncomingDynamicLink(dynamiclink!)
                }
            }
            if linkHandled{
                return true
            }
            else{
                // do other things with incoming url
                return false
            }
        }
        return false
    }
    
    ///step 3 for dynamicLink
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else{
            print("No dynamicLink URL")
//            goToDirectedVC()
            return
        }
        print("Your Incoming link parameters are \(url.absoluteString)")
        parseDynamicLink(Url: dynamicLink.url!)
    }
    
    ///step 4 for dynamicLink
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            print("I have recieved a url through custom scheme \(url.absoluteString)")
            if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url){
                self.handleIncomingDynamicLink(dynamicLink)
                return true
            }
            else{
                return false
            }
        }
    /// step 5 parsing URL
    func parseDynamicLink(Url : URL) {
        // 1
        if Url.scheme == "https"{
            // 2
            if Url.pathComponents.contains("invite"){
                // 3
                guard let query = Url.query else {
                    return
                }
                // 4
                let components = query.split(separator: ",").flatMap {
                    $0.split(separator: "=")
                }
                // 5
                guard let idIndex = components.firstIndex(of: Substring("user_id")) else {
                    return
                }
                // 6
                guard idIndex + 1 < components.count else {
                    return
                }
                print(components[0])
                print(components[1])
                USER_ID = String(components[1])
                print(USER_ID)
                COME_FROM_LINK = true
                print("all done")
                goToDirectedVC()
            }
        }
    }
    func goToDirectedVC(){
        let isVisited =  UserDefaults.standard.bool(forKey: "isVisited")
        if  isVisited == true {
            if DataManager.sharedInstance.getPermanentlySavedUser()?.AspNetUserID != "" {
                // navigate to home
                if COME_FROM_LINK{
                    let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.tabbar) as! TabBarVC
                    newViewController.selectedIndex = 3
                    let navController = UINavigationController(rootViewController: newViewController)
                    navController.isNavigationBarHidden = true
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                }
                else{
                    let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.home, bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.tabbar) as! TabBarVC
                    let navController = UINavigationController(rootViewController: newViewController)
                    navController.isNavigationBarHidden = true
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.main, bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.signIn)
                let navController = UINavigationController(rootViewController: newViewController)
                navController.isNavigationBarHidden = true
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
            }
        }
        else{
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Ids.main, bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: ViewControllerName.Names.guideVC)
            let navController = UINavigationController(rootViewController: newViewController)
            navController.isNavigationBarHidden = true
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
    }
}

