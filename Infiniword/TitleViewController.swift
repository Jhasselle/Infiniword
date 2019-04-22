//
//  TitleViewController.swift
//  Infiniword
//
//  Created by CampusUser on 4/22/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var LabelTitle: UILabel!
    
    var oldLabelCenter : CGPoint!
    var newLabelCenter : CGPoint!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.LabelTitle.textColor = UIColor(white: CGFloat(1), alpha: CGFloat(0.5))
        self.oldLabelCenter = self.LabelTitle.center
        self.newLabelCenter = CGPoint(x: Double(oldLabelCenter.x), y: Double(self.oldLabelCenter.y + 10))
        
//        UIView.animate(withDuration: 8.0, delay: 0.0, options:[], animations: {
//            //self.LabelTitle.colo
//            self.LabelTitle.textColor = UIColor(white: CGFloat(1), alpha: CGFloat(1))
//        }, completion:nil)
        
        UIView.animate(withDuration: 8.0, delay: 8.0, options:[.autoreverse, .repeat], animations: {
            self.LabelTitle.center = self.newLabelCenter
            self.LabelTitle.textColor = UIColor(white: CGFloat(1), alpha: CGFloat(1))
        }, completion:nil)
        
        startButton.addTarget(self, action: #selector(beginPressed(_:)), for: .touchUpInside)
    }
    
    @objc func beginPressed(_ sender: UIButton) {
        
//        performSegue(withIdentifier: "View Controller", sender: nil)
    }
}
