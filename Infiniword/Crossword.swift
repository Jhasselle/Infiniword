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
    var actualHeight = 0
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
    // MARK:
    // MARK:
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
                Tiles[tileIndex].letter = word[i]
                //Tiles[tileIndex].setTitle(word[i], for: .normal)
                Tiles[tileIndex].backgroundColor = UIColor.white
                Tiles[tileIndex].setTitleColor(UIColor.black, for: .normal)
            }
            // Do NOT increase for each letter when growing horizontal
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
//                Tiles[tileIndex].setTitle(word[i], for: .normal)
                Tiles[tileIndex].backgroundColor = UIColor.white
                Tiles[tileIndex].setTitleColor(UIColor.black, for: .normal)
                
//                print("Word length: \(i)")
//                print("Word tileIndex: \(tileIndex)")
//                print("Word reversedIndex: \(reversedIndex)")
                self.actualHeight += 1
            }
        }
        print("Adding: \(newWordStruct.word)")
        Words.append(newWordStruct)
    }
    
    // MARK:
    // MARK:
    func generateCrossword(dict : DictionaryOverlord) {
        
        
        var steps : [WordStruct] = []
        var stepsPrev : [WordStruct] = []
        var pikes : [WordStruct] = []
        var pikesPrev : [WordStruct] = []
        var landingStep = dict.getRandomWord(size: 9)
        
        // Manual setup for initial tile placement
        var turnIsHorizontal = true
        landingStep.isWordHorizontal = turnIsHorizontal
        landingStep.pos = (2,0)
        setTilesForWord(landingStep)
        steps.append(landingStep)
        
        while (actualHeight + width < height) {
            turnIsHorizontal = !turnIsHorizontal

            
            if !turnIsHorizontal { // Turn is Vertical
                pikesPrev = pikes
                
                let newPikes : [WordStruct] = findPikes(steps: steps, pikesPrev: pikesPrev, dict: dict)
                pikes = newPikes

                var pikeNum = 0
                for pike in pikes {
//                    print("pike.word: \(pike.word)")
//                    print("pikeNum:\(pikeNum)")
                    pikeNum += 1
                    setTilesForWord(pike)
                }

            }
            else { // Turn is horizontal
                stepsPrev = steps
                let newSteps : [WordStruct] = findSteps(stepsPrev: stepsPrev, pikes: pikes, dict: dict)
                steps = newSteps
                
                var stepNum = 0
                for step in steps {
//                    print("step.word: \(step.word)")
//                    print("stepNum:\(stepNum)")
                    stepNum += 1
                    setTilesForWord(step)
                }
            }
//            actualHeight += 20
        }
    }
    
    
    // MARK:
    // MARK:
    func findPikes(steps : [WordStruct], pikesPrev : [WordStruct], dict : DictionaryOverlord) -> [WordStruct] {
        print ("\n\t\tfindPikes")
        
        let landingStep = steps[0]
        
        // select the uniform pike height for this iteration
        let pikeHeight = Int.random(in: 10 ... 13)
        
        // landingStep.pos
        let stepWidth = landingStep.word.count
        
        
        //        while (pikeLeftRelativeX != )
        let pikeLeftRelativeX = Int.random(in: 0 ... (stepWidth/3) - 1)
        let pikeMiddleRelativeX = Int.random(in: (stepWidth/3) ... (stepWidth*2/3) - 1)
        let pikeRightRelativeX = Int.random(in: (stepWidth*2/3) ... (stepWidth) - 1)
        
        
//        print("\npikeLeftRelativeX = \(pikeLeftRelativeX)" )
//        print("pikeMiddleRelativeX = \(pikeMiddleRelativeX)" )
//        print("pikeRightRelativeX = \(pikeRightRelativeX)" )
//
        
        
        let pikeLeftEndingChar = Character(landingStep.word[pikeLeftRelativeX])
        let pikeMiddleEndingChar = Character(landingStep.word[pikeMiddleRelativeX])
        let pikeRightEndingChar = Character(landingStep.word[pikeRightRelativeX])
//        print("pikeLeftEndingChar = \(pikeLeftEndingChar)" )
//        print("pikeMiddleEndingChar = \(pikeMiddleEndingChar)" )
//        print("pikeRightEndingChar = \(pikeRightEndingChar)" )
        
        
        var numOfTries = 0
        var pikeLeft = dict.getRandomPike(letter: pikeLeftEndingChar, index: pikeHeight - 1, newMaxSize: pikeHeight)
        while (pikeLeft.word == "x" && pikeHeight - numOfTries > 4) {
            pikeLeft = dict.getRandomPike(letter: pikeLeftEndingChar, index: pikeHeight - numOfTries - 1, newMaxSize: 13)
            numOfTries += 1
        }

        
        numOfTries = 0
        var pikeMiddle = dict.getRandomPike(letter: pikeMiddleEndingChar, index: pikeHeight - 1, newMaxSize: pikeHeight)
        while (pikeMiddle.word == "x" && pikeHeight - numOfTries > 4) {
            pikeMiddle = dict.getRandomPike(letter: pikeMiddleEndingChar, index: pikeHeight - numOfTries - 1, newMaxSize: 13)
            numOfTries += 1
        }
      
        numOfTries = 0
        var pikeRight = dict.getRandomPike(letter: pikeRightEndingChar, index: pikeHeight - 1, newMaxSize: pikeHeight)
        
        while (pikeRight.word == "x" && pikeHeight - numOfTries > 4) {
            pikeRight = dict.getRandomPike(letter: pikeRightEndingChar, index: pikeHeight - numOfTries - 1, newMaxSize: 13)
            numOfTries += 1
        }
        
        pikeLeft.isWordHorizontal = false
        pikeMiddle.isWordHorizontal = false
        pikeRight.isWordHorizontal = false
        
        
        
        pikeLeft.pos = (landingStep.pos.x + pikeLeftRelativeX, landingStep.pos.y + pikeLeft.word.count - 1)
        pikeMiddle.pos = (landingStep.pos.x + pikeMiddleRelativeX, landingStep.pos.y + pikeMiddle.word.count - 1)
        pikeRight.pos = (landingStep.pos.x + pikeRightRelativeX, landingStep.pos.y + pikeRight.word.count - 1)
        
//        print(pikeLeft.pos)
//        print(pikeMiddle.pos)
//        print(pikeRight.pos)
        
        pikeLeft.wordIndex = Words.count
        Words.append(pikeLeft)
        pikeMiddle.wordIndex = Words.count
        Words.append(pikeMiddle)
        pikeRight.wordIndex = Words.count
        Words.append(pikeRight)
        
        let returnPikes = [pikeLeft, pikeMiddle, pikeRight]
//        returnPikes.append(pikeLeft)
//        returnPikes.append(pikeMiddle)
//        returnPikes.append(pikeRight)
//
        return returnPikes
    }

    
    
    
    
    
    
    
    
//    // MARK:
//    // MARK:
//    func findSteps(stepsPrev : [WordStruct], pikes : [WordStruct], dict : DictionaryOverlord) -> [WordStruct] {
//
//        print ("\n\t\tfindSteps")
//
//        var returnSteps : [WordStruct] = []
//        var leftPikePos = (x:-1, y:-1)
//        var middlePikePos = (x:-1, y:-1)
//        var rightPikePos = (x:-1, y:-1)
//
//
//        leftPikePos = pikes[0].pos
//        let leftPike = pikes[0]
//
//        middlePikePos = pikes[1].pos
//        let middlePike = pikes[1]
//
//        rightPikePos = pikes[2].pos
//        let rightPike = pikes[2]
//
//        // A good starting heuristic
////        let landingStartPosX = Int.random(in: 0 ... 1)
//        let landingStartPosX = 0
//        var newWordStruct : WordStruct
//        // If our heuristic went past the left pike, then move on
//
//        print("landingStartPosX: ", landingStartPosX)
//        print("leftPikePos: ", leftPikePos)
//        print("leftPike:", leftPike.word)
//        print("middlePike:", middlePike.word)
//        print("rightPike:", rightPike.word)
//
//        if landingStartPosX <= leftPikePos.x  {
//            print("step if")
//
//           // if (pikes.count )
//            let letter_1_index = leftPike.pos.x - landingStartPosX
//            let letter_1 = Character(pikes[0].word[0])
//
//            let letter_2_index = middlePike.pos.x - landingStartPosX
//            let letter_2 = Character(middlePike.word[0])
//
//            newWordStruct = dict.getRandomWord(letter1: letter_1, letterIndex1: letter_1_index, letter2: letter_2, letterIndex2: letter_2_index, newMaxSize: 13)
//
//            newWordStruct.pos = (landingStartPosX, pikes[1].pos.y)
//            newWordStruct.wordIndex = Words.count
//            Words.append(newWordStruct)
//            returnSteps.append(newWordStruct)
//
//            return returnSteps
//        }
//        else {
//
//            print("step else")
//
//            let letter_1_index = leftPike.pos.x - landingStartPosX
//            let letter_1 = Character(middlePike.word[0])
//
//            let letter_2_index = rightPike.pos.x - landingStartPosX
//            let letter_2 = Character(rightPike.word[0])
//
//            let letter_3_index = rightPike.pos.x - landingStartPosX
//            let letter_3 = Character(rightPike.word[0])
//
//
////            newWordStruct = dict.getRandomWord(letter1: letter_1, letterIndex1: letter_1_index, letter2: letter_2, letterIndex2: letter_2_index, newMaxSize: 13 - landingStartPosX)
//            newWordStruct = dict.getRandomWordForStep(letter1: <#T##Character#>, letter1_pos_x: <#T##Int#>, letter2: <#T##Character#>, letter2_pos_x: <#T##Int#>, letter3: <#T##Character#>, letter3_pos_x: <#T##Int#>)
//
//            newWordStruct.pos = (landingStartPosX, pikes[1].pos.y)
//            newWordStruct.wordIndex = Words.count
//            Words.append(newWordStruct)
//            returnSteps.append(newWordStruct)
//
//            return returnSteps
//        }
//    }
    
    // MARK:
    // MARK:
    func findSteps(stepsPrev : [WordStruct], pikes : [WordStruct], dict : DictionaryOverlord) -> [WordStruct] {
        
        print ("\n\t\tfindSteps")
        
        var returnSteps : [WordStruct] = []

        var leftPike : WordStruct
        leftPike = pikes[0]
        var middlePike : WordStruct
        middlePike = pikes[1]
        var rightPike : WordStruct
        rightPike = pikes[2]
        
        let landingStartPosX = 0
        var newWordStruct : WordStruct

        let letter_1_index = leftPike.pos.x - landingStartPosX - 1
        let letter_1 = Character(leftPike.word[0])

        let letter_2_index = middlePike.pos.x - landingStartPosX - 1
        let letter_2 = Character(middlePike.word[0])

        let letter_3_index = rightPike.pos.x - landingStartPosX - 1
        let letter_3 = Character(rightPike.word[0])

        newWordStruct = dict.getRandomWordForStep(letter1: letter_1, letter1_pos_x: letter_1_index, letter2: letter_2, letter2_pos_x: letter_2_index, letter3: letter_3, letter3_pos_x: letter_3_index)
        newWordStruct.pos = (letter_1_index - newWordStruct.pos.x + 1, pikes[0].pos.y)
        
        if newWordStruct.word == "x" {
            print("oh no!")
            newWordStruct = dict.getRandomWord_2(letter1: letter_1, letter1_pos_x: letter_1_index, letter2: letter_2, letter2_pos_x: letter_2_index, newMaxSize : 13)
        }
        
        if newWordStruct.word == "x" {
            print("OH NO!")
            
            newWordStruct = dict.getRandomWord(size: 8)
            newWordStruct.pos = (0, pikes[0].pos.y + 2)
        }
        
        newWordStruct.wordIndex = Words.count
        Words.append(newWordStruct)
        returnSteps.append(newWordStruct)
        
        return returnSteps
        
    }
    
    
//    func generateCrossword(dict : DictionaryOverlord) {
//
//        var currentHeight = 0
//        var turnIsHorizontal = true
//        //var prevWordGiftPos = (x:0,y:0)
//        var prevVertPosX = 0
//        var currentWordStruct = dict.getRandomWord(size: 9)
//        currentWordStruct.pos = (0,0)
//        var prevWordStruct = currentWordStruct
//        setTilesForWord(currentWordStruct)
//        Words.append(currentWordStruct)
//        currentHeight += 1
//        print("Adding: \(currentWordStruct.word)")
//
//        while (currentHeight + width < height) {
//
//            turnIsHorizontal = !turnIsHorizontal
//            if !turnIsHorizontal { // Turn is Vertical
//
//
//                // This assignment and loop prevents stacking vertical words
////                var currentVerticalPosX = prevVertPosX
////                while currentVerticalPosX == prevVertPosX {
////                   currentVerticalPosX = Int.random(in: prevWordStruct.pos.x ... (prevWordStruct.word.count - 1))
////                }
//
//
//                // Pick random index from the horizontal word to grow our vertical word
//                // Use this index as the last character of our word we want.
//                // We don't have to worry about bounds, as we are always free to grow upward.
//                let currentVerticalPosX = Int.random(in: prevWordStruct.pos.x ... (prevWordStruct.word.count - 1))
//
//                let prevWordIndexLetter = Character(prevWordStruct.word[currentVerticalPosX])
//
//                currentWordStruct = dict.getRandomWord(letter: prevWordIndexLetter, index: prevWordStruct.word.count - 1, newMaxSize: width)
//                currentWordStruct.isWordHorizontal = false
//
//                currentWordStruct.pos = ((currentVerticalPosX), (prevWordStruct.pos.y + (currentWordStruct.word.count - 1)))
//                currentHeight += currentWordStruct.word.count
//
//                prevVertPosX = currentVerticalPosX
//            }
//            else { // Turn is horizontal
//                let prevWordLetterIndex = prevWordStruct.pos.x
//                let prevWordLetter = Character(prevWordStruct.word[prevWordLetterIndex])
//                currentWordStruct = dict.getRandomWord(letter: prevWordLetter, index: prevVertPosX, newMaxSize: width)
//                currentWordStruct.pos = (0, prevWordStruct.pos.y)
//            }
//
//
//            print("Adding: \(currentWordStruct.word)")
//            currentWordStruct.wordIndex = Words.count
//            prevWordStruct = currentWordStruct
//            Words.append(currentWordStruct)
//            setTilesForWord(currentWordStruct)
//
//        }
//    }
    
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
            Tiles[i].backgroundColor = UIColor.init(white: CGFloat(1), alpha: CGFloat(0))
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
