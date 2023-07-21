//
//  AlertUtils.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 21.07.2023.
//

import Foundation
import UIKit

// MARK: Tekrarlayan alertleri bir classta toplamak amacıyla
class AlertUtils {
    
    static func showAlert(from viewController: UIViewController, withMessage message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showCustomAlert(from viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showSuccessAlert(from viewController: UIViewController, withMessage message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "Successful", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                completion?()
            }
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
        }
}
