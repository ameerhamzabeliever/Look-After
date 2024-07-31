//
//  Helper.swift
//  MobileApp
//
//  Created by Hamza's Mac on 03/12/2021.
//

import UIKit

class Helper{
    static func setImage(imageView : UIImageView, imageUrl: String) {
        var placeholder = UIImage()
        placeholder = PLACEHOLDER_USER!
        let stringURL = imageUrl.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: stringURL) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, placeholder: placeholder)
        }
    }
    static func utcToLocalDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let date = dateFormatter.date(from: dateStr)! // create date from string

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    static func utcToLocalTime(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let date = dateFormatter.date(from: dateStr)! // create date from string

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
