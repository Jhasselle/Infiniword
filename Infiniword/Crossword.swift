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
    var width = 3 // lowest allowed value
    var height = 0 // random heuristic, lets seeeee
    var Rows = [UIStackView]()
    var Tiles = [Tile]()
//    var TileGrid = [[Tile]]()
    var Words = [WordStruct]()
    var enabled = false
    var displayHeight = 50
    
    func initialize(width:Int, height:Int) {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.backgroundColor = UIColor.blue
        self.spacing = CGFloat(5.0)
        self.width = width
        self.height = height
        displayHeight = width + 5
    }
    
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
                Tiles[tileIndex].backgroundColor = UIColor.gray
                
            }
        }
        //isVertical
        else {
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
                Tiles[tileIndex].backgroundColor = UIColor.gray
            }
        }
    }
    
    func generateCrossword(dict : DictionaryOverlord) {
        
        var currentHeight = 0
        var turnIsHorizontal = true
        var prevWordGiftPos = (x:0,y:0)
        var prevVertXPos = 0
        var currentWordStruct = dict.getRandomWord(size: width)
        setTilesForWord(currentWordStruct)
        var prevWordStruct = currentWordStruct

        print(currentWordStruct.word)
        while (currentHeight + width < height) {
            turnIsHorizontal = !turnIsHorizontal
            prevWordStruct = currentWordStruct
            
            // This is where the new word is being placed above, if vert
            if turnIsHorizontal {
                currentWordStruct = dict.getRandomWord(size: width)
                var prevWordLetterIndex = prevWordStruct.pos.x
                var prevWordLetter = Character(prevWordStruct.word[prevWordLetterIndex])
                dict.getRandomWord(letter: prevWordLetter, index: prevVertXPos, width)
                
                currentWordStruct.pos = (0, prevWordStruct.pos.y)
                
                
            }
            else { // Turn is vertical
                var prevWordRandIndex = Int.random(in: 0 ... (prevWordStruct.word.count - 1))
                while prevVertXPos == prevWordRandIndex {
                    prevWordRandIndex = Int.random(in: 0 ... (prevWordStruct.word.count - 1))
                }
                prevVertXPos = prevWordRandIndex
                var prevWordRandLetter = Character(prevWordStruct.word[prevWordRandIndex])
                currentWordStruct = dict.getRandomWord(letter: prevWordRandLetter, index: width - 1, width)
                
                currentHeight += currentWordStruct.word.count
                currentWordStruct.isWordHorizontal = false
                currentWordStruct.pos = (prevWordStruct.pos.x + prevWordRandIndex, prevWordStruct.pos.y + currentWordStruct.word.count)
            }
            
            
            print("Adding: \(currentWordStruct.word)")
            currentWordStruct.wordIndex = Words.count
            Words.append(currentWordStruct)
            setTilesForWord(currentWordStruct)
            
        }
        
        
    }
    
    func highlightWord(wordIndex : Int){
        print("highlightWord(wordIndex : Int)")
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
