//
//  UIVC+Ext.swift
//  MobileApp
//
//  Created by Hamza's Mac on 01/11/2021.
//

import Foundation
import UIKit
extension UIViewController
{
    func presentModal(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion:nil)
    }
    func convertToUTC(dateToConvert : String) ->String{
        let formatter = DateFormatter()
             formatter.dateFormat = "MM/dd/yyyy hh:mm"
             let convertedDate = formatter.date(from: dateToConvert)
             formatter.timeZone = TimeZone(identifier: "UTC")
             return formatter.string(from: convertedDate!)
    }
}
