//
//  CrosswordManager.swift
//  Infiniword
//
//  Created by CampusUser on 4/3/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//
import UIKit
import Foundation

// For later positioning, we may have to manually set up the ui view
class Crossword: UIStackView {
    var width = 13 // lowest allowed value
    var height = 64 // random heuristic, lets seeeee
    var Rows = [UIStackView]()
    var currentRowIndex = 0
    var Tiles = [Tile]()
    var Words = [WordStruct]()
    var enabled = false
    var displayHeight = 13
    
    var currentWord = WordStruct()
    
    func initialize(width:Int, height:Int) {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.backgroundColor = UIColor.blue
        self.spacing = CGFloat(3.0)
        self.width = width
        self.height = height
        self.displayHeight = 13
    }
    
    
    // Input: correctly defined WordStruct
    //
    func setTilesForWord(_ newWordStruct: WordStruct) {
    
        let wordLength = newWordStruct.word.count
        let word = newWordStruct.word
        let x = newWordStruct.pos.x
        let y = newWordStruct.pos.y
        let isHorizontal = newWordStruct.isWordHorizontal
        var relativeX = 0
        var relativeY = 0
        
        if (isHorizontal) {
            for i in 0..<wordLength {
                relativeX = x + i
                relativeY = y
                let tileIndex = (relativeY * width) + relativeX
                
                
                Tiles[tileIndex].active = true
                Tiles[tileIndex].xWordExists = true
                Tiles[tileIndex].xWordPos = (x, y)
                Tiles[tileIndex].xWordIndex = newWordStruct.wordIndex
                Tiles[tileIndex].setTitle(word[i], for: .normal)
                Tiles[tileIndex].backgroundColor = UIColor.white
                Tiles[tileIndex].setTitleColor(UIColor.black, for: .normal)
            }
        }
        //isVertical
        else {
//            print("Word string: \(newWordStruct.word)")
            for i in (0..<wordLength).reversed() {
                
                relativeX = x
                relativeY = y - i
                let tileIndex = (relativeY * width) + relativeX
                //let reversedIndex = wordLength - i - 1
                Tiles[tileIndex].active = true
                Tiles[tileIndex].yWordExists = true
                Tiles[tileIndex].yWordPos = (x, y)
                Tiles[tileIndex].yWordIndex = newWordStruct.wordIndex
                Tiles[tileIndex].letter = word[i]
                Tiles[tileIndex].setTitle(word[i], for: .normal)
                Tiles[tileIndex].backgroundColor = UIColor.white
                Tiles[tileIndex].setTitleColor(UIColor.black, for: .normal)
                
//                print("Word length: \(i)")
//                print("Word tileIndex: \(tileIndex)")
//                print("Word reversedIndex: \(reversedIndex)")
            }
        }
    }
    
    func generateCrossword(dict : DictionaryOverlord) {
        
        var currentHeight = 0
        var turnIsHorizontal = true
        //var prevWordGiftPos = (x:0,y:0)
        var prevVertPosX = 0
        var currentWordStruct = dict.getRandomWord(size: 6)
        currentWordStruct.pos = (0,0)
        var prevWordStruct = currentWordStruct
        setTilesForWord(currentWordStruct)
        Words.append(currentWordStruct)
        currentHeight += 1
        print("Adding: \(currentWordStruct.word)")
        
        while (currentHeight + width < height) {
            
            turnIsHorizontal = !turnIsHorizontal
            if !turnIsHorizontal { // Turn is Vertical
                
                
                // This assignment and loop prevents stacking vertical words
//                var currentVerticalPosX = prevVertPosX
//                while currentVerticalPosX == prevVertPosX {
//                   currentVerticalPosX = Int.random(in: prevWordStruct.pos.x ... (prevWordStruct.word.count - 1))
//                }
                

                // Pick random index from the horizontal word to grow our vertical word
                // Use this index as the last character of our word we want.
                // We don't have to worry about bounds, as we are always free to grow upward.
                let currentVerticalPosX = Int.random(in: prevWordStruct.pos.x ... (prevWordStruct.word.count - 1))
                
                let prevWordIndexLetter = Character(prevWordStruct.word[currentVerticalPosX])
                
                currentWordStruct = dict.getRandomWord(letter: prevWordIndexLetter, index: prevWordStruct.word.count - 1, newMaxSize: width)
                currentWordStruct.isWordHorizontal = false
                
                currentWordStruct.pos = ((currentVerticalPosX), (prevWordStruct.pos.y + (currentWordStruct.word.count - 1)))
                currentHeight += currentWordStruct.word.count
                
                prevVertPosX = currentVerticalPosX
            }
            else { // Turn is horizontal
                let prevWordLetterIndex = prevWordStruct.pos.x
                let prevWordLetter = Character(prevWordStruct.word[prevWordLetterIndex])
                currentWordStruct = dict.getRandomWord(letter: prevWordLetter, index: prevVertPosX, newMaxSize: width)
                currentWordStruct.pos = (0, prevWordStruct.pos.y)
            }
            
            
            print("Adding: \(currentWordStruct.word)")
            currentWordStruct.wordIndex = Words.count
            prevWordStruct = currentWordStruct
            Words.append(currentWordStruct)
            setTilesForWord(currentWordStruct)
            
        }
    }
    
    func hideRow(rowIndex : Int) {
//        print("Hiding row: \(rowIndex)")
        let startingTileIndex = width * rowIndex
        for i in 0...width-1 {
            Tiles[startingTileIndex + i].hide()
            Tiles[startingTileIndex + i].disable()
        }
    }
    
    func showRow(rowIndex : Int) {
        
//        print("Showing row: \(rowIndex)")
        let startingTileIndex = width * rowIndex
        
        if rowIndex < Rows.count {
            for i in 0...width-1 {
                Tiles[startingTileIndex + i].show()
                Tiles[startingTileIndex + i].enable()
            }
        }
        else {
            print("nice try")
        }
    }
    
    // Deletes bottommost row
    func deleteRow() {
        print("Deleting row: \(currentRowIndex)")
        let startingTileIndex = currentRowIndex * width
        print("startingTileIndex: \(startingTileIndex)")
        for i in 0...width-1 {
            //Make every Tile remove itself
            Tiles[startingTileIndex + i].hide()
            Tiles[startingTileIndex + i].removeFromSuperview()
            if Tiles[startingTileIndex + i].yWordExists {
//                print(Words[Tiles[startingTileIndex + i].yWordIndex].clue)
            }
        }
        Rows[currentRowIndex].removeFromSuperview()
        showRow(rowIndex: currentRowIndex + displayHeight)
        print("Showing row: \(currentRowIndex + displayHeight)")
        currentRowIndex += 1
    }
    
    func highlightWord(wordIndex : Int) {
        clearHighlighting()
        print("highlighting word: \(wordIndex)")
        var (x, y) = Words[wordIndex].pos
        var tileIndex = (13 * y) + x
        var increment : Int
        let randomColor = self.getRandomColor()
        
        if Words[wordIndex].isWordHorizontal {
            for i in 0..<Words[wordIndex].word.count{
                increment = (tileIndex + i)
                UIView.animate(withDuration: 1.0, delay: 0.0, options:[], animations: {
                    self.Tiles[increment].backgroundColor = randomColor
                }, completion:nil)
            }
        }
        else {
        
            for i in 0..<Words[wordIndex].word.count{
                increment = (tileIndex - (i * 13))
                //Tiles[increment].backgroundColor = UIColor.red
                UIView.animate(withDuration: 1.0, delay: 0.0, options:[], animations: {
                    self.Tiles[increment].backgroundColor = randomColor
                }, completion:nil)
            }
        }
    }
    
    func highlightWords(wordHorizontalIndex : Int, wordVerticalIndex : Int) {
        highlightWord(wordIndex : wordHorizontalIndex)
        highlightWord(wordIndex : wordVerticalIndex)
    }
    
    func clearHighlighting() {
        for i in 0..<(height*width) {
            if Tiles[i].yWordExists || Tiles[i].xWordExists {
                Tiles[i].backgroundColor = UIColor.white
            }
            else {
            Tiles[i].backgroundColor = UIColor.black
            }
        }
    }
    
    // MARK:
    // MARK: Anime Stuff
    var counter = 0
    var timer = Timer()
    
    func getRandomColor() -> UIColor {
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // start timer
    @IBAction func startTimerButtonTapped(sender: UIButton) {
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        counter += 1
    }
}

struct WordStruct {
    var word = ""
    var hints = ""
    var clue = ""
    var wordLength = 0
    var isWordCorrect = false
    var isWordHorizontal = true
    var pos = (x:0, y:0)
    var wordIndex = 0
}
