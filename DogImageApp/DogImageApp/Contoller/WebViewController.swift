//
//  WebViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/28.
//

import UIKit
import WebKit


class WebViewController: UIViewController {

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://digital-greens.web.app")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    

}

extension WebViewController: WKUIDelegate {
    // delegate
}

// MARK: - 11 WKWebView WKNavigation delegate
extension WebViewController: WKNavigationDelegate {
    // delegate
}
