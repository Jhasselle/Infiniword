//
//  ViewController.swift
//  Infiniword
//
//  Created by CampusUser on 4/3/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var DEBUG_DELETE = 0
    
    @IBOutlet var KeyboardStackview: UIStackView!
    @IBOutlet var MasterStackview: UIStackView!
    var crossword : Crossword!
    var currentTile = Tile()
    let dictionaryOverlord = DictionaryOverlord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCustomViews()
        initializeKeyboard()
    }
    
// MARK: Crossword Stuff
    func initializeCustomViews() {
        initializeMasterStackview()
        initializeKeyboardView()
        initializeCrossword()
    }
    
    func initializeMasterStackview() {
        MasterStackview.axis = .vertical
        MasterStackview.alignment = .fill
        MasterStackview.distribution = .fillEqually
        MasterStackview.spacing = CGFloat(5.0)
    }
    
    func initializeCrossword() {
        crossword = Crossword()
        crossword.initialize(width: 8, height: 64)
        initializeCrosswordRows()
        MasterStackview.addArrangedSubview(crossword)
        crossword.generateCrossword(dict: dictionaryOverlord)
        
        //DEBUG
        //crossword.DEBUG_GENERATE_CROSSWORD()
    }
    
    func initializeCrosswordRows() {
        
        var tileIndex = 0
        for y in 0..<crossword.height {
            let newRow = UIStackView()
            newRow.axis = .horizontal
            newRow.alignment = .fill
            newRow.distribution = .fillEqually
            newRow.spacing = CGFloat(5.0)
            
            for x in 0..<crossword.width {
                let newTile = Tile()
                newTile.tileIndex = tileIndex
                tileIndex += 1
                newTile.initialize(xIndex: x, yIndex: y)
                newTile.addTarget(self, action: #selector(tilePressed(_:)), for: .touchUpInside)
                if (y > crossword.displayHeight - 1) {
                    newTile.disable()
                    newTile.hide()
                }
                else {
                    newTile.enable()
                    newTile.show()
                }
                crossword.Tiles.append(newTile)
                newRow.addArrangedSubview(newTile)
                
            }
            crossword.Rows.append(newRow)
            crossword.insertArrangedSubview(newRow, at: 0)
            
        }
    }

    // MARK: Tile Stuff
    @IBAction func tilePressed(_ sender: Tile) {
        currentTile = sender
        var wordIndex = -1
        
        if sender.xWordExists {
            wordIndex = sender.xWordIndex
            crossword.highlightWord(wordIndex: wordIndex)
        }
        if sender.yWordExists {
            wordIndex = sender.yWordIndex
            crossword.highlightWord(wordIndex: wordIndex)
        }
    }
    
// MARK: Keyboard Stuff
    func initializeKeyboardView() {
        KeyboardStackview.axis = .vertical
        KeyboardStackview.alignment = .fill
        KeyboardStackview.distribution = .fillEqually
        KeyboardStackview.spacing = CGFloat(5.0)
    }
    
    func initializeKeyboard() {
        let alphabet = "QWERTYUIOPASDFGHJKLZXCVBNM"
        
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.alignment = .fill
        row1.distribution = .equalSpacing
        row1.spacing = CGFloat(5.0)
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.alignment = .fill
        row2.distribution = .equalSpacing
        row2.spacing = CGFloat(5.0)
        
        let row3 = UIStackView()
        row3.axis = .horizontal
        row3.alignment = .fill
        row3.distribution = .equalSpacing
        row3.spacing = CGFloat(5.0)
        
        var currentIndex = 0
        
        for char in alphabet {
            let newKeyboardButton = KeyboardButton()
            let newLetter = String(char)
            newKeyboardButton.letter = newLetter
            newKeyboardButton.setTitle(newLetter, for: .normal)
            newKeyboardButton.backgroundColor = UIColor.blue
            newKeyboardButton.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
            
            if currentIndex <= 9 {
                row1.addArrangedSubview(newKeyboardButton)
            }
            else if currentIndex <= 18 {
                row2.addArrangedSubview(newKeyboardButton)
            }
            else if currentIndex <= 25 {
                row3.addArrangedSubview(newKeyboardButton)
            }
            currentIndex += 1
        }
        
        // row1, 0 - 9, Q - P
        // row2, 10 - 18, A - L
        // row3, 19 - 25, Z - M
        KeyboardStackview.addArrangedSubview(row1)
        KeyboardStackview.addArrangedSubview(row2)
        KeyboardStackview.addArrangedSubview(row3)
    }
    
    
    
    
    var DEBUG_KEYBOARDNUMPRESSED = 0
    var DEBUG_LETTER1 = "a"
    var DEBUG_LETTER2 = "b"
    
    @IBAction func keyboardPressed(_ sender: KeyboardButton) {
    
        

        crossword.deleteRow()
        crossword.clearHighlighting()
        
        if DEBUG_KEYBOARDNUMPRESSED == 0 {
            DEBUG_LETTER1 = sender.letter
            DEBUG_KEYBOARDNUMPRESSED += 1
        }
        else {
            DEBUG_LETTER2 = sender.letter
            
            var newWordStruct = dictionaryOverlord.getRandomWord(letter1: Character(DEBUG_LETTER1), letterIndex1: 0, letter2: Character(DEBUG_LETTER2), letterIndex2: 3, 0)
//            print(newWordStruct.word)
            
            DEBUG_KEYBOARDNUMPRESSED = 0
        }
    }
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    // MARK: Gesture Stuff
//    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
//    
    
    
    
    
}

