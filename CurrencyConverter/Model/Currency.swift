//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/27/21.
//  Copyright © 2021 Morenikeji. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

struct Currency {
    var symbol : String
    
    init(symbol: String) {
        self.symbol = symbol
    }
}


