//
//  ZHWordListTableViewController.swift
//  EnglishStudy
//
//  Created by Apple on 2019/6/12.
//  Copyright © 2019 livall. All rights reserved.
//

import UIKit

class ZHWordListTableViewController: UITableViewController {
    
    var totalWordsList = ZFWordListProwider.shared().totalWordsList!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WordCell")
        title = "单词表"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 26
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        let alphaIndex = 65+indexPath.row
        let char = Character(UnicodeScalar(alphaIndex)!)
        cell.textLabel?.text = "单词：" + String(char)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alphaIndex = 65+indexPath.row
        let char = Character(UnicodeScalar(alphaIndex)!)
        let key = String(char)
        performSegue(withIdentifier: "gotoDetailList", sender: totalWordsList[key])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetailList" {
            let wordList = segue.destination as! ZFWordDetailListTableViewController
            wordList.wordsList = sender as! Array<WordInfo>
        }
    }

}
