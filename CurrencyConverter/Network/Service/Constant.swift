//
//  Constant.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/26/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import Foundation

struct Constant {
    //Base URL
    static let BASE_URL = "http://data.fixer.io/api/"
    static let ACCESS_KEY = "55c393df5e4e452a02f2e57a2f973cc7"
    static let BASE_SYMBOL = "EUR"
    
    
    //User APIs
    static let LATEST = "\(Constant.BASE_URL)latest"
    static let CONVERT = "\(Constant.BASE_URL)convert"
    
}

