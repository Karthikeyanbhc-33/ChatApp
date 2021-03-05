//
//  CustomProgressView.swift
//  ChatApp
//
//  Created by Karthikeyan on 05/03/21.
//

import Foundation
import UIKit

protocol ShowInstanceAlert {
    
}
extension ShowInstanceAlert where Self: UIViewController {
    func showInstantAlert(alertTitle: String, alertMessage: String) {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }  
}





