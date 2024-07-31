//
//  TableViewCell+Ext.swift
//  MobileApp
//
//  Created by Hamza's Mac on 03/01/2022.
//

import Foundation
import UIKit

extension UITableViewCell{
    func showToast(message : String) {
        DispatchQueue.main.async {
            var toastLabel = UILabel()
            toastLabel = UILabel(frame: CGRect(x: self.contentView.bounds.width/4 , y: self.contentView.bounds.height - 70, width: self.contentView.bounds.width/2, height: 30 ))
            toastLabel.layer.cornerRadius = toastLabel.frame.height/2
            toastLabel.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.5176470588, blue: 0.5490196078, alpha: 1)
            toastLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.clipsToBounds  =  true
            self.contentView.addSubview(toastLabel)
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    func convertToUTC(dateToConvert : String) ->String{
        let formatter = DateFormatter()
             formatter.dateFormat = "MM/dd/yyyy hh:mm"
             let convertedDate = formatter.date(from: dateToConvert)
             formatter.timeZone = TimeZone(identifier: "UTC")
             return formatter.string(from: convertedDate!)
    }
}
