//
//  Results.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/26/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Results<T> {
    case success(JSON)
    case failure(Error)
    
    func get() -> JSON{
        switch self{
        case .success(let data):
            return data
        default: return JSON([])
        }
    }
    
}

