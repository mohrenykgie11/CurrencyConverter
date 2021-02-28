//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/27/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import Foundation
import RealmSwift

class CurrencyObject: Object {
    @objc dynamic var symbol : String = ""

    override static func primaryKey() -> String? {
        return "symbol"
    }
}

extension CurrencyObject {
    //realm object init
    convenience init(currency : Currency) {
        self.init()
        self.symbol = currency.symbol
    }
}

extension CurrencyObject {
    //realm object init
    convenience init(object : CurrencyObject) {
        self.init()
        self.symbol = object.symbol
    }
}
