//
//  Helper.swift
//  MobileApp
//
//  Created by Hamza's Mac on 09/11/2021.
//

import Foundation

class Helper{
    static func replaceSpaces(checkSpaceUrl : String) -> String{
        let urlConverted = checkSpaceUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return urlConverted
        
    }
}
