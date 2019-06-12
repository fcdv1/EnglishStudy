//
//  ZFWordListProwider.swift
//  EnglishStudy
//
//  Created by Apple on 2019/6/12.
//  Copyright © 2019 livall. All rights reserved.
//

import UIKit

class ZFWordListProwider: NSObject {
    private static var sharedNetworkManager: ZFWordListProwider = ZFWordListProwider()
    class func shared() -> ZFWordListProwider {
        return sharedNetworkManager
    }
    var unknowWordSets = Set<String>()
    
    override init() {
        super.init()
        loadAllWords()
    }
    
    //所有单词，包括熟悉的和不熟悉的
    var totalWordsList:Dictionary<String,Array<WordInfo>>?

    //所有不熟悉的词
    var totalUnKnowWordsList:Dictionary<String,Array<WordInfo>>?
    
    func loadAllWords() {
        //1,读取文本内容，输出所有的单词名词
        let path = Bundle.main.path(forResource: "word", ofType: nil)
        let text = try! String(contentsOfFile: path!)
        let array = text.split(separator: "\n")
        
        //提取出所有的单词
        var wordArray = Array<WordInfo>()
        for item in array {
            //提取出所有的词
            let subArray = item.split(separator: " ")
            if subArray.count >= 3{
                let name = subArray[1]
                let infos = subArray[2...]
                let detail = infos.joined(separator: " ")
                print(name + " " + detail)
                let word = WordInfo()
                word.word = String(name)
                word.textInfo = detail
                wordArray.append(word)
            }
        }
        //对所有的单词进行排序
        wordArray = wordArray.sorted { (a, b) -> Bool in
            let result = a.word.compare(b.word)
            if result == .orderedAscending{
                return true
            }
            return false
        }
        print(wordArray.count)
        for word in wordArray {
            print(word.word)
        }
        
        //生成字典
        var arrays = [Array<WordInfo>](repeating: [], count: 26)
        for word in wordArray {
            let cha = word.word.first!
            let asc = Int(cha.asciiValue!)
            var value = asc  - 97
            if value < 0{
                value = asc - 65
            }
            arrays[Int(value)].append(word)
        }
        var dic = Dictionary<String,Array<WordInfo>>()
        for i in 0...25 {
            let alphaIndex = 65+i
            let char = Character(UnicodeScalar(alphaIndex)!)
            dic[String(char)] = arrays[i]
        }
        totalWordsList = dic
    }
    
    func isInUnKnowList(word:WordInfo) -> Bool {
        return unknowWordSets.contains(word.word)
    }
    
    func addUnknowWord(word:WordInfo) {
        if unknowWordSets.contains(word.word) {
            return
        }
        unknowWordSets.insert(word.word)
        let key = keyForWord(word: word)
        var array = totalWordsList![key]
        array?.append(word)
    }
    func removeUnknowWord(word:WordInfo) {
        if !unknowWordSets.contains(word.word) {
            return
        }
        let key = keyForWord(word: word)
        var array = totalWordsList![key]
        if let index = array?.firstIndex(of:word) {
            array?.remove(at: index)
        }
    }
    
    func keyForWord(word:WordInfo) -> String {
        let cha = word.word.first!
        let key = String(cha)
        return key
    }
}
