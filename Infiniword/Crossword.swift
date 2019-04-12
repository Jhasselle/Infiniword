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
    var width = 5 // lowest allowed value
    var height = 64 // random heuristic, lets seeeee
    var Rows = [UIStackView]()
    var numberOfRows = 0
    var currentRowIndex = 0
    var Tiles = [Tile]()
    var Words = [WordStruct]()
    var enabled = false
    var displayHeight = 13
    
    func initialize(width:Int, height:Int) {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.backgroundColor = UIColor.blue
        self.spacing = CGFloat(5.0)
        self.width = width
        self.height = height
        self.numberOfRows = width * height
        self.displayHeight = width * 3
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
                let reversedIndex = wordLength - i - 1
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
        var currentWordStruct = dict.getRandomWord(size: width)
        var prevWordStruct = currentWordStruct
        setTilesForWord(currentWordStruct)
        currentHeight += 1
        
//        print(currentWordStruct.word)
        while (currentHeight + width < height) {
            turnIsHorizontal = !turnIsHorizontal
            if !turnIsHorizontal { // Turn is Vertical
                
                // Pick random index to grow our vertical word from
                var currentVerticalPosX = prevVertPosX
                while currentVerticalPosX == prevVertPosX {
                    currentVerticalPosX = Int.random(in: prevWordStruct.pos.x ... (prevWordStruct.word.count - 1))
                }
                
                
                let prevWordIndexLetter = Character(prevWordStruct.word[currentVerticalPosX])
                
                currentWordStruct = dict.getRandomWord(letter: prevWordIndexLetter, index: width - 1, width)
                currentWordStruct.isWordHorizontal = false
                
                currentWordStruct.pos = ((currentVerticalPosX), (prevWordStruct.pos.y + (currentWordStruct.word.count - 1)))
                currentHeight += currentWordStruct.word.count
                
                prevVertPosX = currentVerticalPosX
            }
            else { // Turn is horizontal
                //let prevWordLetterIndex = prevWordStruct.pos.x
                let prevWordLetter = Character(prevWordStruct.word[0])
                currentWordStruct = dict.getRandomWord(letter: prevWordLetter, index: prevVertPosX, width)
                currentWordStruct.pos = (0, prevWordStruct.pos.y)
            }
            
            
//            print("Adding: \(currentWordStruct.word)")
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
        for i in 0...width-1 {
            Tiles[startingTileIndex + i].show()
            Tiles[startingTileIndex + i].enable()
        }
    }
    
    // Deletes bottommost row
    func deleteRow() {
//        print("Deleting row: \(currentRowIndex)")
        let startingTileIndex = currentRowIndex * width
        
        for i in 0...width-1 {
            //Make every Tile remove itself
            Tiles[startingTileIndex + i].removeFromSuperview()
            if Tiles[startingTileIndex + i].yWordExists {
//                print(Words[Tiles[startingTileIndex + i].yWordIndex].clue)
            }
        }
        Rows[currentRowIndex].removeFromSuperview()
        showRow(rowIndex: currentRowIndex + displayHeight)
        currentRowIndex += 1
    }
    
    func highlightWord(wordIndex : Int){
    }
    
    func highlightWords(wordHorizontalIndex : Int, wordVerticalIndex : Int) {
        
    }
    
    func clearHighlighting() {
        for i in 0..<(height*width) {
            if Tiles[i].yWordExists || Tiles[i].xWordExists {
                Tiles[i].backgroundColor = UIColor.yellow
            }
            else {
            Tiles[i].backgroundColor = UIColor.black
            }
            
        }
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
