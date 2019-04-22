//
//  DictionaryManager.swift
//  Infiniword
//
//  Created by CampusUser on 4/3/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

// json reference: https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift

import Foundation

class DictionaryOverlord {
    
    // A list of all the words and their related data
    var WordList = [DictionaryEntry]()
    
    init() {
        
        if let path = Bundle.main.path(forResource: "dictionaries/eng_dict", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let wordArray = try JSONSerialization.jsonObject(with: data, options:.mutableLeaves) as? [Any]
                let numOfWords = try Int(wordArray!.count)
                
                for i in 0..<numOfWords {
                    // JSONSerialization by default is turning each entry of this {"word":"definition"} JSON array into a legacy dictionary of size one.
                    // I want all my words in a simple array, so I'm casting(?) them into the current non-legacy Dictionary in order to get the key value pair.
                    let testDict = wordArray![i] as! Dictionary<String,String>
                    for (key, value) in testDict {
                        
                        //Adding each word to our wordlist "dictionary"
                        var newEntry = DictionaryEntry()
                        newEntry.word = key
                        newEntry.definition = value
                        newEntry.createWordArr()
                        WordList.append(newEntry)
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
                // handle error
            }
        }
    }
    
    
    // MARK:
    // MARK:
    // Parameters: Size, the number of letters.
    // Returns: Wordstruct of the random word.
    func getRandomWord(size:Int) -> WordStruct {

        var newWordStruct = WordStruct()
        var numOfTries = 0
        let maxTries = WordList.count
        while (numOfTries < maxTries) {
            let number = Int.random(in: 0 ... (WordList.count - 1))
            if (WordList[number].word.count == size){
                newWordStruct.word = WordList[number].word.uppercased()
                newWordStruct.clue = WordList[number].definition
                break
            }
            numOfTries += 1
        }
        
        return newWordStruct
    }
    

    // MARK:
    // MARK:
    // Parameters: Size, the number of letters.
    // Returns: Wordstruct
    func getRandomWord(letter : Character, index : Int, newMaxSize : Int) -> WordStruct {
        var maxSize = newMaxSize
        if maxSize == 0 {
            maxSize = 13
        }
        var newWordStruct = WordStruct()
        var startingSearchIndex = Int.random(in: 0 ... (WordList.count - 1))
        var found = false
        for i in startingSearchIndex...(WordList.count - 1) {
            if (!found) {
                if WordList[i].size - 1 >= index && WordList[i].size <= maxSize && WordList[i].size > 3{
                    if WordList[i].wordCharArr[index] == letter {
                        newWordStruct.word = WordList[i].word
                        newWordStruct.clue = WordList[i].definition
                        newWordStruct.wordLength = newWordStruct.word.count
//                        print("random word: \(newWordStruct.word)")
//                        print("WordList.count: \(WordList.count)")
//                        print("startingSearchIndex: \(startingSearchIndex)")
                        found = true
                        break
                    }
                }
            }
        }
        if !found {
            startingSearchIndex = 0
            for i in startingSearchIndex...(WordList.count - 1) {
                if (!found) {
                    if WordList[i].size - 1 >= index && WordList[i].size <= maxSize  && WordList[i].size > 3{
                        if WordList[i].wordCharArr[index] == letter {
                            newWordStruct.word = WordList[i].word
                            newWordStruct.clue = WordList[i].definition
                            newWordStruct.wordLength = newWordStruct.word.count
//                            print("random word: \(newWordStruct.word)")
//                            print("WordList.count: \(WordList.count)")
//                            print("startingSearchIndex: \(startingSearchIndex)")
                            found = true
                            break
                        }
                    }
                }
            }
        }
        
        return newWordStruct
    }
    
    
    // MARK:
    // MARK:
// This is the brute force implementation of the word search.
// It will allow up to 2 indexes to each be checked for their respective letters
    func getRandomWord(letter1 : Character, letterIndex1 : Int, letter2 : Character, letterIndex2 : Int, newMaxSize : Int) -> WordStruct {
        print("\tStart getRandomWord()")
        var maxSize = newMaxSize
        if maxSize == 0 {
            maxSize = 13
        }
        var newWordStruct = WordStruct()
        newWordStruct.word = "x"
        let startingSearchIndex = 0
        
        print("letter1: \(letter1)")
        print("letterIndex1: \(letterIndex1)")
        print("letter2: \(letter2)")
        print("letterIndex2: \(letterIndex2)")
        
        for i in startingSearchIndex...(WordList.count - 1) {
            
                if WordList[i].size - 1 >= letterIndex2 && WordList[i].size <= maxSize && WordList[i].size > 3 {
//                    print(WordList[i].word)
                    
                    
                    var j = 0
                    while (j + letterIndex2 - letterIndex1) < WordList[i].size - 1{
//                        print(WordList[i].size)
//                        print(j)
                        
                        
                        let tempLetter1 = WordList[i].wordCharArr[j]
//                        print ("tempLetter1: \(tempLetter1)")
                        
                        let tempLetter2 = WordList[i].wordCharArr[j + (letterIndex2 - letterIndex1) - 1]
//                        print ("tempLetter2: \(tempLetter2)")
                        
                        if  letter1 == tempLetter1 && letter2 == tempLetter2 && (j + (letterIndex2 - letterIndex1 - 1)) < WordList[i].size {
                            newWordStruct.word = WordList[i].word
                            newWordStruct.clue = WordList[i].definition
                            newWordStruct.wordLength = newWordStruct.word.count
//                            print("random word: \(newWordStruct.word)")
//                            print("WordList.count: \(WordList.count)")
//                            print("startingSearchIndex: \(startingSearchIndex)")
                            break
                        }
                        j += 1
                    }
                }
        }
    
        
        print("\tEnd getRandomWord(), returning newWordStruct: ", newWordStruct.word)
        return newWordStruct
    }
    
    func getRandomWordForStep(letter1 : Character, letter1_pos_x : Int, letter2 : Character, letter2_pos_x : Int, letter3 : Character, letter3_pos_x : Int) -> WordStruct {
        
        print("\tStart getRandomWordForStep()")
        
        var newWordStruct = WordStruct()
        newWordStruct.word = "x"
        let maxSize = 13
        let startingSearchIndex = 0
        
        for i in startingSearchIndex...(WordList.count - 1) {
            
            if WordList[i].size - 1 > letter3_pos_x && WordList[i].size <= maxSize && WordList[i].size > 4 {
                //                    print(WordList[i].word)
                
                
                var j = 0
                while (j + letter3_pos_x - letter1_pos_x) < WordList[i].size - 1 {
                    //                        print(WordList[i].size)
                    //                        print(j)
//                    print("letter1: ", letter1)
//                    print("j: ", j)
//                    print("letter2: ", letter2)
//                    print("j + (letter2_pos_x - letter1_pos_x) - 1: ", j + (letter2_pos_x - letter1_pos_x) - 1)
                    
                    
                    let tempLetter1 = WordList[i].wordCharArr[j]
                    //                        print ("tempLetter1: \(tempLetter1)")
                    
                    let tempLetter2 = WordList[i].wordCharArr[j + (letter2_pos_x - letter1_pos_x)]
                    //                        print ("tempLetter2: \(tempLetter2)")
                    
                    let tempLetter3 = WordList[i].wordCharArr[j + (letter3_pos_x - letter1_pos_x)]
                    
                    if  letter1 == tempLetter1 && letter2 == tempLetter2 && (j + (letter3_pos_x - letter1_pos_x)) < WordList[i].size {
//                        print("letter1: ", letter1)
//                        print("j: ", j)
//                        print("letter2: ", letter2)
//                        print("j + (letter2_pos_x - letter1_pos_x) - 1: ", j + (letter2_pos_x - 1))
                        
                        newWordStruct.word = WordList[i].word
                        newWordStruct.clue = WordList[i].definition
                        newWordStruct.wordLength = newWordStruct.word.count
                        newWordStruct.pos.x = j
                        if letter3 == tempLetter3 {
                            print("\n\t\t***FOUND A TRIPLE!!!***\n")
                            print("\n\t\t***\(newWordStruct.word)***\n")
                            print("\n\t\t***\(tempLetter1), \(tempLetter2), \(tempLetter3), ***\n")
                            print("\n\t\t***\(j), \(j + (letter2_pos_x - letter1_pos_x)), \(j + (letter3_pos_x - letter1_pos_x)), ***\n")
                            print("\tEnd getRandomWordForStep(), returning newWordStruct: ", newWordStruct.word)
                            return newWordStruct
                        }
                    }
                    j += 1
                }
            }
        }
        
        
        print("\tEnd getRandomWord(), returning newWordStruct: ", newWordStruct.word)
        return newWordStruct
    }
    
    
    // #2
    func getRandomWord_2(letter1 : Character, letter1_pos_x : Int, letter2 : Character, letter2_pos_x : Int, newMaxSize : Int) -> WordStruct {
        print("\tStart getRandomWord #4")
        var maxSize = newMaxSize
        if maxSize == 0 {
            maxSize = 13
        }
        var newWordStruct = WordStruct()
        newWordStruct.word = "x"
        let startingSearchIndex = 0
        
        print("letter1: \(letter1)")
        print("letterIndex1: \(letter1_pos_x)")
        print("letter2: \(letter2)")
        print("letterIndex2: \(letter2_pos_x)")
        
        for i in startingSearchIndex...(WordList.count - 1) {
            
            if WordList[i].size - 1 >= letter2_pos_x && WordList[i].size <= maxSize && WordList[i].size > 3 {
                //                    print(WordList[i].word)
                
                
                var j = 0
                while (j + letter2_pos_x - letter1_pos_x) < WordList[i].size - 1{
                    //                        print(WordList[i].size)
                    //                        print(j)
                    
                    
                    let tempLetter1 = WordList[i].wordCharArr[j]
                    //                        print ("tempLetter1: \(tempLetter1)")
                    
                    let tempLetter2 = WordList[i].wordCharArr[j + (letter2_pos_x - letter1_pos_x) - 1]
                    //                        print ("tempLetter2: \(tempLetter2)")
                    
                    if  letter1 == tempLetter1 && letter2 == tempLetter2 && (j + (letter2_pos_x - letter1_pos_x - 1)) < WordList[i].size {
                        print("letter1: ", letter1)
                        print("j: ", j)
                        print("letter2: ", letter2)
                        print("j + (letter2_pos_x - letter1_pos_x) - 1: ", j + (letter2_pos_x - letter1_pos_x) - 1)
                        newWordStruct.pos.x = j
                        newWordStruct.word = WordList[i].word
                        newWordStruct.clue = WordList[i].definition
                        newWordStruct.wordLength = newWordStruct.word.count
                        //                            print("random word: \(newWordStruct.word)")
                        //                            print("WordList.count: \(WordList.count)")
                        //                            print("startingSearchIndex: \(startingSearchIndex)")
                        return newWordStruct
                    }
                    j += 1
                }
            }
        }
        
        
        print("\tEnd getRandomWord(), returning newWordStruct: ", newWordStruct.word)
        return newWordStruct
    }
    
    
    func getRandomPike(letter : Character, index : Int, newMaxSize : Int) -> WordStruct {
        var maxSize = newMaxSize
        if maxSize == 0 {
            maxSize = 13
        }
        var newWordStruct = WordStruct()
        newWordStruct.word = "x"
        var startingSearchIndex = Int.random(in: 0 ... (WordList.count - 1))
        var found = false
        for i in startingSearchIndex...(WordList.count - 1) {
            if (!found) {
                if WordList[i].size - 1 >= index && WordList[i].size <= maxSize && WordList[i].size > 3{
                    if WordList[i].wordCharArr[index] == letter {
                        newWordStruct.word = WordList[i].word
                        newWordStruct.clue = WordList[i].definition
                        newWordStruct.wordLength = newWordStruct.word.count
                        //                        print("random word: \(newWordStruct.word)")
                        //                        print("WordList.count: \(WordList.count)")
                        //                        print("startingSearchIndex: \(startingSearchIndex)")
                        found = true
                        break
                    }
                }
            }
        }
        if !found {
            startingSearchIndex = 0
            for i in startingSearchIndex...(WordList.count - 1) {
                if (!found) {
                    if WordList[i].size - 1 >= index && WordList[i].size <= maxSize  && WordList[i].size > 3{
                        if WordList[i].wordCharArr[index] == letter {
                            newWordStruct.word = WordList[i].word
                            newWordStruct.clue = WordList[i].definition
                            newWordStruct.wordLength = newWordStruct.word.count
                            //                            print("random word: \(newWordStruct.word)")
                            //                            print("WordList.count: \(WordList.count)")
                            //                            print("startingSearchIndex: \(startingSearchIndex)")
                            found = true
                            break
                        }
                    }
                }
            }
        }
        
        
        return newWordStruct
    }
    
}





struct DictionaryEntry {
    var word = ""
    var definition = ""
    var wordCharArr : [Character] = []
    var size = 0
    
    mutating func createWordArr() {
        for char in word {
            size += 1
            wordCharArr.append(char)
        }
        
    }
}
