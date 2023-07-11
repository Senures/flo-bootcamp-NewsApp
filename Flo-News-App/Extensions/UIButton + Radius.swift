//
//  UIButton + Radius.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 14.06.2023.
//

import Foundation
import UIKit


extension UIButton {
    func applyCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
    }
}
