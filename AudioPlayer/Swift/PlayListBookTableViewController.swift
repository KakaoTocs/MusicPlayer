//
//  PlayListBookTableViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 12. 3..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

class PlayListBookTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var Current = 0
    
    @IBOutlet weak var PlayListTable: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //PlayListBook[Current].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var i = 0
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicListCell", forIndexPath: indexPath) as! ListTableViewCell
        
        cell.MusicTitle.text = MusicList[PlayListBook[Current][indexPath.row]]
        cell.MusicSinger.text = SingerList[PlayListBook[Current][indexPath.row]]
        print(PlayListBook[Current][indexPath.row])
        
        i += 1
        /*
        MusicArtLoading(indexPath.row)
        cell.MusicWork.image =  UIImage(data: ImageTemp!)
        */
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Current)
        
        PlayListTable.dataSource = self
        PlayListTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        PlayListTable.reloadData()
    }
}
