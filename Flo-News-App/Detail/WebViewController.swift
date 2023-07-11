//
//  WebViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 27.06.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
       private var url: URL
       
       init(url: URL) {
           self.url = url
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           webView = WKWebView(frame: view.bounds)
           view.addSubview(webView)
           
           let request = URLRequest(url: url)
           webView.load(request)
       }

}
