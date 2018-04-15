//
//  HomeListViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 11. 20..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Foundation

var MusicCount = 0
var Now = 0

var MusicList = [""]
var SingerList = [""]
var AlbumList = [""]
var MusicArt = [""]

let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

class HomeListViewController: UIViewController, UITableViewDataSource, AVAudioPlayerDelegate, UISearchBarDelegate, UITableViewDelegate {
    
    var audioFileURL : NSURL!
    var audioPath : NSURL!
    var ImageTemp : NSData!
    
    @IBOutlet weak var MusicLIstTable: UITableView!;
    
    func checkMusicList(){
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            //print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.flatMap({$0.URLByDeletingPathExtension?.lastPathComponent})
            //print("mp3 list:", mp3FileNames)
            MusicList = mp3FileNames
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func MusicLoading()
    {
        var cur = 0
        for List in MusicList{
            audioFileURL = NSBundle(URL: documentsUrl)!.URLForResource(List, withExtension: "mp3")
            //print(audioFileURL)
            let ListItem = AVPlayerItem(URL: audioFileURL)
            let matadataList = ListItem.asset.metadata
            
            for item in matadataList {
                
                if item.commonKey == "artist" {
                    if SingerList[0] == ""{
                        SingerList[0] = item.stringValue!
                    }
                    else{
                        SingerList.append(item.stringValue!)
                    }
                }
                
                if item.commonKey == "albumName"{
                    if AlbumList[0] == ""{
                        AlbumList[0] = item.stringValue!
                    }
                    else{
                        AlbumList.append(item.stringValue!)
                    }
                }
                
                if item.commonKey == "artwork"{
                    let Image = UIImage(data: item.value as! NSData)
                    ImageTemp = UIImagePNGRepresentation(Image!)
                }
                cur += 1
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { //섹션 개수를 1로 설정
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //섹션당 열개수 전달
        return MusicList.count
    }
    
    func MusicArtLoading(ImageTempCur : Int)
    {
            audioFileURL = NSBundle(URL: documentsUrl)!.URLForResource(MusicList[ImageTempCur], withExtension: "mp3")
            let ListItem = AVPlayerItem(URL: audioFileURL)
            let matadataList = ListItem.asset.metadata
            
            for item in matadataList {
                if item.commonKey == "artwork"{
                    //let Image = UIImage(data: item.value as! NSData)
                    let Image = UIImage(data: item.value as! NSData)
                    ImageTemp = UIImagePNGRepresentation(Image!)
                }
            }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicListCell", forIndexPath: indexPath) as! ListTableViewCell
        
            cell.MusicTitle.text = MusicList[indexPath.row]
            cell.MusicSinger.text = SingerList[indexPath.row]
            MusicArtLoading(indexPath.row)
            cell.MusicWork.image =  UIImage(data: ImageTemp!)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(documentsUrl)
        checkMusicList()
        MusicLoading()
        
        MusicLIstTable.dataSource = self
        MusicLIstTable.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem() //Edit버튼 삭제\
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) { //뷰가 노출 될떄마다 리스트 데이터 다시 불러옴
        MusicLIstTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sgPlay"{
            let cell = sender as! UITableViewCell
            let indexPath = self.MusicLIstTable.indexPathForCell(cell)
            let PlayerView = segue.destinationViewController as! PlayerViewController
            
            if(Now == 1)
            {
                PlayerView.StopAudio()
                print(Now)
            }
            
            PlayerView.Current = indexPath!.row //목록중 선택한 노래 넘버 전달
        }
    }
}
