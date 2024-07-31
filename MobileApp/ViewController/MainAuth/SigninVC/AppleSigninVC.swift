//
//  AppleSigninVC.swift
//  MobileApp
//
//  Created by TecSpine on 20/09/2021.
//

import UIKit
import AuthenticationServices


@available(iOS 13.0, *)
class AppleSignin: NSObject {

    static var shared = AppleSignin()
    
    private var onSuccess:((AppleDetails)->())?
    
    public func initAppleSignin(scope: [ASAuthorization.Scope]?,completion: @escaping (AppleDetails)->Void) {
        self.onSuccess = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = scope
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

//MARK:- Delegate

@available(iOS 13.0, *)
extension AppleSignin: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let name = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                switch credentialState {
                case .authorized: // The Apple ID credential is valid.
                    print("user valid")
                    let firstName = (name?.givenName ?? "")
                    let lastName = (name?.familyName ?? "")
                    let appleData = AppleDetails(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email, error: nil)
                    self.onSuccess?(appleData)
                    break
                case .revoked: // The Apple ID credential is revoked.
                    print("user credential is revoked")
                    let firstName = (name?.givenName ?? "")
                    let lastName = (name?.familyName ?? "")
                    let appleData = AppleDetails(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email, error: "apple id credential is revoked")
                    self.onSuccess?(appleData)
                    break
                case .notFound:
                    print("user not found")
                    let firstName = (name?.givenName ?? "")
                    let lastName = (name?.familyName ?? "")
                    let appleData = AppleDetails(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email, error: "user not found")
                    self.onSuccess?(appleData)
                    break
                default:
                    print("user .... wrong")
                    let firstName = (name?.givenName ?? "")
                    let lastName = (name?.familyName ?? "")
                    let appleData = AppleDetails(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email, error: "some thing want wrong")
                    self.onSuccess?(appleData)
                    break
                }
            }
           
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            let appleData = AppleDetails(userId: nil, firstName: nil, lastName: nil, email: nil, error: error.localizedDescription)
            print("error", error)
            self.onSuccess?(appleData)
        }
        
    }
}

@available(iOS 13.0, *)
extension AppleSignin: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
       let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        return keyWindow!
    }
    
}

class AppleDetails {
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var error: String?
    
    init(userId: String?, firstName: String?, lastName: String?, email: String?, error: String?) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.error = error
        
    }
}

