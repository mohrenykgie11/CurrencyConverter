//
//  ReusableAlert.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/26/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import Foundation
import UIKit

class AlertView: NSObject {
    
    class func showAlert(view: UIViewController , title: String , message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
}
