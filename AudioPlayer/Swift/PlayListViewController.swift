//
//  PlayListBookViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 12. 2..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

var PlayListBook :[[Int]] = [[Int]](count: 10, repeatedValue:[Int](count: 20, repeatedValue: 0))

class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var PlayList = ["Lv", "POP"]
    
    @IBOutlet weak var PlayListTable: UITableView!
    
    func Setting(){ //
        PlayListBook[0][0] = 2
        PlayListBook[0][1] = 7
        PlayListBook[0][2] = 9
        
        PlayListBook[1][0] = 1
        PlayListBook[1][1] = 0
        PlayListBook[1][2] = 8
        PlayListBook[1][3] = 10
        PlayListBook[1][4] = 14
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { //섹션 개수를 1로 설정
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //섹션당 열개수 전달
        return PlayList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayListCell", forIndexPath: indexPath) as! PlayListTableViewCell
        
        cell.PlayListTitle.text = PlayList[indexPath.row]
        cell.PlayListImage = nil
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Setting()
        
        PlayListTable.dataSource = self
        PlayListTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        PlayListTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sgListBook"{
            let cell = sender as! UITableViewCell
            let indexPath = self.PlayListTable.indexPathForCell(cell)
            let PlayListView = segue.destinationViewController as! PlayListBookTableViewController
            
            PlayListView.Current = indexPath!.row //목록중 선택한 노래 넘버 전달
        }
    }
}
