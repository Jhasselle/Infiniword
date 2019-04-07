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
            return CGSize(width: 25, height: 25)
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
    }
    
    func adjustViewFit() {
        
        self.backgroundColor = UIColor.purple
        // Title
        let newTitle = " \(xIndex),\(yIndex)"
        self.setTitle(newTitle, for: UIControl.State.normal)
    }
    
    func enable() {
        self.isEnabled = true
        self.backgroundColor = UIColor.magenta
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = UIColor.black
    }
    
    func hide() {
        self.isHidden = true
        active = false
    }
    
    func show() {
        self.isHidden = false
        active = true
    }
    
    func isComplete() -> Bool {
        return (xWordComplete && yWordComplete)
    }
}

class KeyboardButton : UIButton {
    var letter = ""
    
}





