//
//  BaseClass.swift
//  MobileApp
//
//  Created by TecSpine on 15/09/2021.
//

import UIKit
import JGProgressHUD
import SDWebImage

class BaseVC: UIViewController {
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let defaults = UserDefaults.standard
    var isReload = true
    
    func RegisterXib(tableviewMain :UITableView , RegisterXib : [String]){
        
        for indexObj in RegisterXib {
            tableviewMain.register(UINib.init(nibName: indexObj, bundle: nil), forCellReuseIdentifier: indexObj)
        }
    }
   
    //MARK: Alert Messge
    //MARK:
    func showToast(message : String) {
        DispatchQueue.main.async {
            var toastLabel = UILabel()
            toastLabel = UILabel(frame: CGRect(x: 20 , y: self.view.bounds.height / 2, width: self.view.bounds.width - 40, height: 40 ))
            toastLabel.layer.cornerRadius = 20.0
            toastLabel.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.5176470588, blue: 0.5490196078, alpha: 1)
            toastLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    func ShowAlertWithHandler(title: String = "" , message: String, DismissButton : String = "No", completion: ((_ status: Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DismissButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(false)
        })
       
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowAlertWithCompletaion(title: String = "" , message: String, isError: Bool , DismissButton : String = "No" , AcceptButton : String = "Yes", completion: ((_ status: Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DismissButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(false)
        })
        alert.addAction(UIAlertAction(title: AcceptButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ShowAlertforPhoto(completion: ((_ status: Int) -> Void)? = nil) {
        
        let alert = UIAlertController(title: "" , message: "Choose source", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(1)
        })
        alert.addAction(UIAlertAction(title: "Phone Gallery", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(2)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(3)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowErrorAlert(message : String , AlertTitle : String = "") {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ShowSuccessAlert(message : String , AlertTitle : String = "") {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
//            _ = self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithDismiss(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: {
                
            })
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithrootView(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithViewRemove(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.view.removeFromSuperview()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func TabbarHide(status : Bool){
        self.tabBarController?.tabBar.isHidden = status
    }
    
    //MARK: Navigation Actions
    //MARK:
    
    func GetViewcontrollerWithName(nameViewController : String) -> UIViewController {
        let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as UIViewController
        return viewObj
    }
    
    
   
    
    func PushViewWithIdentifier(name : String ) {
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.pushViewController(viewPush!, animated: true)
    }
    
    func PushViewWithStoryBoard(name : String , StoryBoard : String ) {
        
        let viewController = self.GetView(nameViewController: name, nameStoryBoard: StoryBoard)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func ShowViewWithIdentifier(name : String ) {
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.present(viewPush!, animated: true) {
            
        }
    }

    func ShowMainDashBoard(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMainView"), object: nil)
    }
    
    
    
    //MARK:- Custom methods
    func showLoading() {
        
        
        let viewLoader = UIView.init(frame: UIScreen.main.bounds)
        viewLoader.backgroundColor = UIColor.init(red: (0.0), green: (0.0), blue: (0.0), alpha: 0.4)
        viewLoader.tag = -6000

        
        let window = UIApplication.shared.keyWindow
        
        window!.addSubview(viewLoader)

        let hud = JGProgressHUD(style: .extraLight)
        hud.textLabel.text = "Loading"
        hud.show(in: viewLoader)


        self.view.isUserInteractionEnabled = false
        
    }
    func hideLoading() {
        self.view.isUserInteractionEnabled = true
        
        let window = UIApplication.shared.keyWindow
        
        window!.viewWithTag(-5000)?.removeFromSuperview()
        window!.viewWithTag(-6000)?.removeFromSuperview()
    }
}


// MARK:
// MARK: Project Bottom Cell
extension BaseVC {
    
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
    }
    
    
    func CheckNullValue(value : AnyObject) -> String{
        if ((value as? String) != nil) {
            return value as! String
            
        }else if ((value as? Int) != nil) {
            return String(value as! Int)
        }else  if ((value as? Double) != nil)  {
            return String(value as! Double)
        }else {
            return ""
        }
    }
    
}

class ResponseModel: NSObject {
    
    func ReturnValue(value : Any) -> String{
        if let MainValue = value as? Int {
            return String(MainValue)
        }else  if let MainValue = value as? String {
            return MainValue
        }else  if let MainValue = value as? Double {
            return String(MainValue)
        }
        return ""
    }
    
    
}

