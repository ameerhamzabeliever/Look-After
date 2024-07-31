//
//  TableView+Ext.swift
//  MobileApp
//
//  Created by Hamza's Mac on 01/11/2021.
//

import Foundation
import UIKit
extension UITableView {
    
    func setEmptyMessageForTbl(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width,
            height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }
    
    func restoreForTbl() {
        self.backgroundView = nil
    }

}

