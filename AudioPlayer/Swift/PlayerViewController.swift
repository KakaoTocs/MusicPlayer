//
//  ViewController.swift
//  AudioPlayer
//
//  Created by dshs_student on 2016. 9. 23..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController, AVAudioPlayerDelegate{
    var cnt = 0
    var Current = 0

    var audioPlayer : AVAudioPlayer!
    var audioFile : NSURL!
    
    let MAX_VOLUME : Float = 15.0
    
    var progressTimer : NSTimer!
    let timePlayerSelector:Selector = #selector(PlayerViewController.updatePlayTime)
    var MusicBook = ""

    @IBOutlet weak var MusicTitle: UILabel!
    @IBOutlet weak var MusicDetailContents: UILabel!
    @IBOutlet weak var MusicImage: UIImageView!
    @IBOutlet weak var MusicBookPage: UITextView!
    
    @IBOutlet weak var ProgressPlay: UIProgressView!
    @IBOutlet weak var CurrentTime: UILabel!
    @IBOutlet weak var EndTime: UILabel!
    
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var ButtonPause: UIButton!
    @IBOutlet weak var ButtonStop: UIButton!
    @IBOutlet weak var Volume: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFile = NSBundle(URL: documentsUrl)!.URLForResource(MusicList[Current], withExtension: "mp3")
        MusicBookPage.userInteractionEnabled = true
        MusicBookPage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.LookMusicBook(_:))))

        initPlay()
        
        MusicBookPage.textColor = UIColor.clearColor()
        MusicBookPage.backgroundColor = UIColor.clearColor()
    }

    func initPlay(){
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioFile)
            //print(audioFile) //파일경로 출력 해줌
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        
        let playItem = AVPlayerItem(URL: audioFile)
        let matadataList = playItem.asset.metadata 
        var Artist = ""
        var AlbumName = ""
        
        for item in matadataList {
            if item.commonKey == "title" {
                MusicTitle.text = item.stringValue!
            }
            
            if item.commonKey == "artist" {
                Artist = item.stringValue!
            }
            
            if item.commonKey == "albumName"{
                AlbumName = item.stringValue!
            }
            
            if item.extendedLanguageTag == "ko"{
                MusicBook = item.stringValue!
            }
            
            if item.commonKey == "artwork"{
                if let audioImage = UIImage(data: item.value as! NSData){
                    MusicImage.image = audioImage
                }
            }
        }
        
        //MusicImage.image = UIImage(named: "image.jpg")
        MusicDetailContents.text = Artist + " - " + AlbumName
        
        Volume.maximumValue = MAX_VOLUME
        
        Volume.value = 1.0 //초기 소리크기
        ProgressPlay.progress = 0 //진행 상태바 초기화
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = Volume.value
        
        EndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        CurrentTime.text = convertNSTimeInterval2String(0)
        
        //AlbumArt?.images = MusicImage
        
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func setPlayButtons(play:Bool, pause:Bool, stop:Bool){
        ButtonPlay.enabled = play
        ButtonPause.enabled = pause
        ButtonStop.enabled = stop
    }
    
    func convertNSTimeInterval2String(time:NSTimeInterval) -> String{
        let min = Int(time/60)
        let sec = Int(time%60)
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonPlayAudio(sender: UIButton) {
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        Now = 1
    }
    
    func updatePlayTime() {
        CurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        ProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }

    @IBAction func ButtonPauseAudio(sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
        
        Now = 1
    }
    
    @IBAction func ButtonStopAudio(sender: UIButton) {
        StopAudio()
    }
    
    func StopAudio(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        CurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, stop: false)
        progressTimer.invalidate()
        Now = 0
    }
    
    @IBAction func ChangeVolume(sender: UISlider) {
        audioPlayer.volume = Volume.value
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func LookMusicBook(sender: AnyObject) {
        print(cnt)
        if(cnt == 0){
            MusicBookPage.textColor = UIColor.blackColor()
            MusicBookPage.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
            MusicBookPage.text = MusicBook
            cnt = 1
        }
        else{
            MusicBookPage.textColor = UIColor.clearColor()
            MusicBookPage.backgroundColor = UIColor.clearColor()
            cnt = 0
        }
    }
}
