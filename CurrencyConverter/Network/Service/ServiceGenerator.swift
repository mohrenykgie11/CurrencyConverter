//
//  ServiceGenerator.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/26/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceGenerator {
    static let shared = ServiceGenerator()
    let accessKey = Constant.ACCESS_KEY
    
    func latest(_ completion: @escaping (Results<Any>) -> ()) {
        AF.request(Constant.LATEST+"?access_key=\(accessKey)", method: .get, encoding: JSONEncoding.default)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
            completion(result)
        }
    }
    
    func convert(base: String, symbol: String, _ completion: @escaping (Results<Any>) -> ()) {
        AF.request(Constant.LATEST+"?access_key=\(accessKey)&base=\(base)&symbols=\(symbol)", method: .get, encoding: JSONEncoding.default)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
            completion(result)
        }
    }


}
