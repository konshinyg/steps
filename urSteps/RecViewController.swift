//
//  RecViewController.swift
//  urSteps
//
//  Created by Core on 11.08.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit
import AVFoundation

class RecViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timerBar: UILabel!
    
    var meterTimer:Timer!
    
    var soundFileURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        setSessionPlayback()
        askForNotifications()
        checkHeadphones()
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if let recorder = self.recorder {
            if recorder.isRecording || player.isPlaying {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                timerBar.text = s
                recorder.updateMeters()
            }
        }
    }
    
    @IBAction func Record(_ sender: UIButton) {
        print("\(#function)")
        
        if player != nil && player.isPlaying {
            print("stopping: recordButton was pressed during Playing")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordButton.setTitle("Pause", for:.normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
            recordButton.setTitle("Continue", for:.normal)
            
        } else {
            print("recording")
            recordButton.setTitle("Pause", for:.normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func Play(_ sender: UIButton) {
        print("\(#function)")
        play()
    }
    
    func play() {
        print("\(#function)")
        
        
        var url:URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(String(describing: url))")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            stopButton.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                   target:self,
                                                   selector:#selector(self.updateAudioMeter(_:)),
                                                   userInfo:nil,
                                                   repeats:true)
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
   
    @IBAction func Stop(_ sender: UIButton) {
        
        print("\(#function)")
                
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", for: .normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.isEnabled = true
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    func recordWithPermission(_ setup:Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target:self,
                                                           selector:#selector(self.updateAudioMeter(_:)),
                                                           userInfo:nil,
                                                           repeats:true)
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission() == .denied {
            print("permission denied")
        }
    }
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() {
        print("\(#function)")
        
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey:             kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey :      32000,
            AVNumberOfChannelsKey:     2,
            AVSampleRateKey :          44100.0
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func askForNotifications() {
        print("\(#function)")
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecViewController.background(_:)),
                                               name:NSNotification.Name.UIApplicationWillResignActive,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecViewController.foreground(_:)),
                                               name:NSNotification.Name.UIApplicationWillEnterForeground,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(RecViewController.routeChange(_:)),
                                               name:NSNotification.Name.AVAudioSessionRouteChange,
                                               object:nil)
    }
    
    func background(_ notification:Notification) {
        print("\(#function)")
        
    }
    
    func foreground(_ notification:Notification) {
        print("\(#function)")
        
    }
    
    
    func routeChange(_ notification:Notification) {
        print("\(#function)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            print("routeChange \(userInfo)")
            
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func checkHeadphones() {
        print("\(#function)")
        
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
}
