//
//  Constant.swift
//  MobileApp
//
//  Created by TecSpine on 15/09/2021.
//

import Foundation
import Alamofire

//MARK:- Constants
var httpHeadersToken : HTTPHeaders {
    get {
        return [
            "Authorization" : UserDefaults.standard.string(forKey: userDefaults.HTTP_HEADERS) ?? ""
        ]
    }
}

//MARK:- Messages
struct MessageConstant {
    
    static let empty            = ""
    static let enterName        = "Please Enter Name"
    static let enterEmail       = "Please Enter Email"
    static let valideEmail      = "Please Enter Valid Email"
    static let enterPassword    = "Please Enter Password"
    static let tooShortPassword = "Password atleast 9 character"
    static let specialCharacter = "Password must have a special character"
    static let upperCharacter   = "Password must have at leat one Uppercase character"
    static let dataSaved        = "Your data is updated successfully."
    static let enterStrongPassword = "Your Password is too Weak. Please enter atleast 6 characters long password."

    
    static let emptyCredentails = "Please provide your credentails to proceed."
    static let wrongEmail       = "Incorrect email format. Please provide a valid email address."
    static let networkNotAvailableMessage = "It appears that you are not connected with internet. Please check your internet connection and try again."

}

//MARK: APIUrl

struct API {
    // Authorization
    static let singUp  = "/api/Account/Register"
    static let singIn  = "/Token"
    static let getInfo = "/api/Account/UserInfo"
    static let registerExternal = "/api/Account/RegisterExternal"
    // activity
    static let getActivities  = "/api/Activity/GetActivities?userId="
    static let createActivity = "/api/Activity/CreateActivity?UserId="
    static let deleteActivty  = "/api/Activity/DeleteActivity?ActivityId="
    static let likeActivity   = "/api/Activity/LikeActivity?userid="
    static let unlikeActivity   = "/api/Activity/DisLikeActivity?userid="
    // friends
    static let addFriends   = "/api/Friends/AddFriends?UserId="
    static let getFriends   = "/api/Friends/GetFriends?UserId="
    static let removeFriend = "/api/Friends/RemoveFriends?UserId="
    
    // comments
    static let addComment   = "/api/Activity/CreateComment?ActivityId="
    
    //update Profile
    static let updateUserInfo = "/api/Account/UpdateUserInfo"
    static let uploadPicture  = "/api/upload/UploadPicture"
    
    //request
    static let createRequest = "/api/HelpRequests/AddUpdateHelpRequest/"
    static let userRequests = "/api/HelpRequests/GetUserHelpRequests?userId="
    static let userFriendHelp = "/api/HelpRequests/GetUserFriendHelpRequests?userId="
    static let acceptRequest = "/api/HelpRequests/AcceptHelpRequest?RequestId="
    static let deleteRequest = "/api/HelpRequests/DeleteHelpRequest?RequestId="
    
    //forget password
    static let generateOtp = "/api/Account/ForgetPassword?Email="
    static let verifyOtp = "/api/Account/VerifyUserOTP?OTP="
    static let updatePassword = "/api/Account/ChangePassword"
}


// MARK:- Storyboard Id
struct Storyboard {
    
    static let Ids = Storyboard()
    
    let main = "Main"
    let home = "Home"
}

//MARK:- XIB Cell Names
struct XIB {
    static let Names  = XIB()
    let createPost    = "PostCell"
    let post          = "userPostVC"
    let helpRequest   = "HelpRequestCell"
    let friendRequest = "FirendRequestCell"
    let userComment   = "UserCommentsCell"
    let myRequest     = "MyRequestCell"
}

//MARK:- XIB Cell Names
struct CellIndentifier {
    static let Names  = XIB()
    let createPost    = "PostCell"
    let post          = "userPostVC"
    let helpRequest   = "HelpRequestCell"
    let friendRequest = "FirendRequestCell"
    let userComment   = "UserCommentsCell"
    let myRequest     = "MyRequestCell"
}



//MARK:- ViewController  Names
struct ViewControllerName {
    static let Names = ViewControllerName()
    
    let guideVC          = "GuideVC"
    let guidePageVC      = "GuidePageVC"
    let getStarted       = "GetStartedVC"
    let signIn           = "LoginViewController"
    let signUp           = "SignUpVC"
    
    let tabbar           = "TabBarVC"
    let home             = "HomeVC"
    let calender         = "CalendarVC"
    let helpRequest      = "HelpRequestVC"
    let postRequest      = "PostRequestVC"
    let friendRequest    = "FriendRequestVC"
    let editprofileVC    = "EditProfileVC"
    let forgotPasswordVC = "ForgotPasswordVC"
    let otpVC            = "OtpVC"
    let updatePassword   = "UpdatePasswordVC"
    let drawerVC         = "DrawerVC"
    let AddCommentVC     = "AddCommentVC"
    let myRequest = "MyRequestVC"
}

/* MARK:- User Defaults */
struct userDefaults {
    static let HTTP_HEADERS    = "httpHeaders"
}
