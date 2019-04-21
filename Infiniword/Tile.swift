//
//  Tile.swift
//  Infiniword
//
//  Created by CampusUser on 4/3/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

import Foundation
import UIKit

class Tile : UIButton {
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 20, height: 20)
        }
    }
    
    var active = false
    var letter = ""
    var yIndex = 0
    var xIndex = 0
    var xWordComplete = false
    var yWordComplete = false
    var xWordIndex = 0
    var yWordIndex = 0
    var xWordPos = (x:0, y:0)
    var yWordPos = (x:0, y:0)
    var xWordExists = false
    var yWordExists = false
    var tileIndex = 0

    // Called manually... I know.......
    func initialize(xIndex : Int, yIndex : Int) {
        // Set Position
        self.xIndex = xIndex
        self.yIndex = yIndex
        adjustViewFit()
        self.disable() // show black box
        self.hide() // make invisible
        self.setTitle("", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func adjustViewFit() {
    }
    
    // Makes invisible or visible
    func hide() {
        self.isHidden = true
        self.alpha = 0
        self.titleLabel!.alpha = 0
    }
    func show() {
        
        self.isHidden = false
        self.alpha = 1
        self.titleLabel!.alpha = 1
        self.setTitleColor(UIColor.black, for: .normal)
        if (xWordExists || yWordExists) {
            self.backgroundColor = UIColor.white
        }
        else {
            self.backgroundColor = UIColor.black
        }
    }
    // Prevents them from being pressed
    func enable() {
        self.isEnabled = true
    }
    
    func disable() {
        self.isEnabled = false
    }
    

    
    
    func isComplete() -> Bool {
        return (xWordComplete && yWordComplete)
    }
}

class KeyboardButton : UIButton {
    var letter = ""
    
}





