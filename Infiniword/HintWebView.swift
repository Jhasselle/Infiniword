//
//  HintWebView.swift
//  Infiniword
//
//  Created by CampusUser on 4/19/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class HintWebView: WKWebView, WKUIDelegate {
    
    
    var webView: WKWebView!
    
    let urlTest = "https://www.google.com/search?q=cute+cat&tbm=isch&hl=en&tbs=qdr:w"
    
    let urlStart = "https://www.google.com/search?q="
    let urlEnd = "&tbm=isch&hl=en&tbs=qdr:w"
    
    func initialize() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
    }
    
    func showWebImages(_ word : String) {
        
        let searchUrl = urlStart + word + urlEnd
        
        let myURL = URL(string:searchUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        print("viewDidLoad()")
        
        print("showWebImages: ", word)
    }
    
    
}
