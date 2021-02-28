////
////  Converter.swift
////  CurrencyConverter
////
////  Created by Morenikeji on 11/22/20.
////  Copyright © 2020 Morenikeji. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//import RealmSwift
//
////struct Symbol {
////    var id : String
////    var partnerId : String
////    var name : String
////    var mediaUrl : String
////    var description : String
////    var createdAt : String
////    var updatedAt : String
////    var deletedAt : String
////
////    init(data: JSON) {
////        self.id = data["id"].stringValue
////        self.partnerId = data["partner_id"].stringValue
////        self.name = data["name"].stringValue
////        self.mediaUrl = data["media_url"].stringValue
////        self.description = data["logo"].stringValue
////        self.createdAt = data["createdAt"].stringValue
////        self.updatedAt = data["updatedAt"].stringValue
////        self.deletedAt = data["deletedAt"].stringValue
////
////    }
////
////
//////    var
//////
//////
//////
//////
//////    "success": true,
//////    "timestamp": 1519296206,
//////    "base": "EUR",
//////    "date": "2020-11-22",
//////    "rates": {
//////        "AUD": 1.566015,
//////        "CAD": 1.560132,
//////        "CHF": 1.154727,
//////        "CNY": 7.827874,
//////        "GBP": 0.882047,
//////        "JPY": 132.360679,
//////        "USD": 1.23396,
//////    [...]
////}
//
//
//
//// MARK: Model
//
////final class SymbolList: Object {
////    dynamic var string = ""
////    let items = List<Task>()
////
////    override static func primaryKey() -> String? {
////        return "id"
////    }
////}
////
////final class Task: Object {
////    dynamic var text = ""
////    dynamic var completed = false
////}
////
//
//
////struct ExchangeRate: Codable {
////    let rate : [String: Double]
////}
//
////struct ExchangeRate {
////    let rate : Double
////    
////    init(data: JSON) {
////        self.rate = data["rates"].doubleValue
////    }
////}
////
////
////class Currency : Object {
////    @objc dynamic var currency = ""
////    @objc dynamic var values = ""
////}
//
//
////from here
////class Currency {
////    var code : String = ""
////    var name : String = ""
////    let symbolArray = List<String>()
////
////    init() {
////    }
////
////    init(data : JSON) {
////        self.code = data.stringValue
////        self.name = data.stringValue
////    }
////}
////
////
////class CurrencyObject: Object {
////    @objc dynamic var code : String = ""
////    @objc dynamic var name : String = ""
////
////    override static func primaryKey() -> String? {
////        return "code"
////    }
////
//////    private static func saveCurrency(in realm: Realm) -> CurrencyObject {
//////        let symbol = CurrencyObject()
//////    }
////}
////
////
////extension CurrencyObject {
////    convenience init(currency : Currency) {
////        self.init()
////        self.code = currency.code
////        self.name = currency.name
////    }
////}
//
//class RealmString: Object {
//    @objc dynamic var stringValue = ""
//}
//
//class CurrencyObject: Object {
//    var symbols: [String] {
//        get {
//            return _backingNickNames.map { $0.stringValue }
//        }
//        set {
//            _backingNickNames.removeAll()
//            _backingNickNames.append(objectsIn: newValue.map({ RealmString(value: [$0]) }))
//        }
//    }
//    let _backingNickNames = List<RealmString>()
////    dynamic var symbols = List<String>()
//
//    override static func ignoredProperties() -> [String] {
//        return [""]//symbols
//    }
//    
//    
////    var code: [String] {
////        get {
////            return symbols.map { $0.stringValue }
////        }
////        set {
////            symbols.removeAll()
////            symbols.append(objectsIn: newValue.map({ RealmString(value: [$0]) }))
////        }
////    }
////
////    let symbols = List<RealmString>()
//}
//
//
//
//
//
//
