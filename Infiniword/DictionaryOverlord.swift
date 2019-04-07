//
//  DictionaryManager.swift
//  Infiniword
//
//  Created by CampusUser on 4/3/19.
//  Copyright © 2019 Ellessah. All rights reserved.
//

// json reference: https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift

import Foundation

struct DictionaryEntry {
    var word = ""
    var definition = ""
    var wordArr : [Character] = []
    var size = 0
    
    mutating func createWordArr() {
        for char in word {
            size += 1
            wordArr.append(char)
        }
        
    }
}

class DictionaryOverlord {
    
    var WordList = [DictionaryEntry]()

    init() {
        
        if let path = Bundle.main.path(forResource: "dictionaries/eng_dict", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let wordArray = try JSONSerialization.jsonObject(with: data, options:.mutableLeaves) as? [Any]
                let numOfWords = try Int(wordArray!.count)

                for i in 0..<numOfWords {
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
    

    
    func getRandomWord(letter : Character, index : Int, _ newMaxSize : Int) -> WordStruct {
        var maxSize = newMaxSize
        if maxSize == 0 {
            maxSize = 20
        }
        var newWordStruct = WordStruct()
        var startingSearchIndex = Int.random(in: 0 ... (WordList.count - 1))
        var found = false
        for i in startingSearchIndex...(WordList.count - 1) {
            if (!found) {
                if WordList[i].size - 1 >= index && WordList[i].size <= maxSize && WordList[i].size > 3{
                    if WordList[i].wordArr[index] == letter {
                        newWordStruct.word = WordList[i].word
                        newWordStruct.clue = WordList[i].definition
                        newWordStruct.wordLength = newWordStruct.word.count
                        print("random word: \(newWordStruct.word)")
                        print("WordList.count: \(WordList.count)")
                        print("startingSearchIndex: \(startingSearchIndex)")
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
                        if WordList[i].wordArr[index] == letter {
                            newWordStruct.word = WordList[i].word
                            newWordStruct.clue = WordList[i].definition
                            newWordStruct.wordLength = newWordStruct.word.count
                            print("random word: \(newWordStruct.word)")
                            print("WordList.count: \(WordList.count)")
                            print("startingSearchIndex: \(startingSearchIndex)")
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

//    func getRandomWord(letter : Character, index : Int) {
//        
//        let startingSearchIndex = Int.random(in: 0 ... (WordList.count - 1))
//        var found = false
//        var word = ""
//        for i in startingSearchIndex...(WordList.count - 1) {
//            if (!found) {
//                if WordList[i].size - 1 >= index {
//                    if WordList[i].wordArr[index] == letter {
//                        word = WordList[i].word
//                        found = true
//                        print("random word: \(word)")
//                        print("WordList.count: \(WordList.count)")
//                        print("startingSearchIndex: \(startingSearchIndex)")
//                        break
//                    }
//                }
//            }
//        }
//    }
//}
