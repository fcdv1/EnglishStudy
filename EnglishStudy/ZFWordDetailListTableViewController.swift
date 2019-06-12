//
//  ZFWordDetailListTableViewController.swift
//  EnglishStudy
//
//  Created by Apple on 2019/6/12.
//  Copyright © 2019 livall. All rights reserved.
//

import UIKit
import AVFoundation

class ZFWordDetailListTableViewController: UITableViewController {
    
    var wordsList = Array<WordInfo>()
    var audioPlayer:AVAudioPlayer?
    var isFromUnRead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isFromUnRead ? "生词表" : "单词总表"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfoCell", for: indexPath)
        let word = wordsList[indexPath.row]
        cell.textLabel?.text = word.word
        cell.detailTextLabel?.text = word.textInfo
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let word = wordsList[indexPath.row]
        let path = Bundle.main.bundlePath+"/fileDoc/"+String(word.word.first!)+"/"+word.word+".mp3"
        playWithPath(path: path)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let word = wordsList[indexPath.row]
        let isNew = ZFWordListProwider.shared().isInUnKnowList(word: word)
        let action = UITableViewRowAction(style: .default, title: isNew ? "移出生词" : "移入生词") { (action, row) in
            if isNew{
                ZFWordListProwider.shared().removeUnknowWord(word: word)
            } else {
                ZFWordListProwider.shared().addUnknowWord(word: word)
            }
        }
        return [action]
    }
    func playWithPath(path:String) {
        if let p = audioPlayer{
            if p.isPlaying{
                p.pause()
            }
        }
        let url = URL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = 2
        audioPlayer?.play()
    }
}
