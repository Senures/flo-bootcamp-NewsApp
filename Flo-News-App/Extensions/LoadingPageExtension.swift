//
//  LoadingPageExtension.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 18.07.2023.
//

import Foundation
import UIKit


extension UIViewController {
    
    private struct ActivityIndicator {
        static var container: UIView?
        static var activityIndicator: UIActivityIndicatorView?
    }

    func showActivityIndicator() {
        let container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        loadingView.center = container.center
        loadingView.backgroundColor = UIColor.white
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        
        container.addSubview(loadingView)
        view.addSubview(container)
        
        ActivityIndicator.container = container
        ActivityIndicator.activityIndicator = activityIndicator
        
        view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        ActivityIndicator.activityIndicator?.stopAnimating()
        ActivityIndicator.container?.removeFromSuperview()
        ActivityIndicator.container = nil
        ActivityIndicator.activityIndicator = nil
        view.isUserInteractionEnabled = true
    }
}
