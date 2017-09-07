//
//  RecTableViewCell.swift
//  urSteps
//
//  Created by Core on 07.09.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit
import AVFoundation

class RecTableViewCell: UITableViewCell,AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var rec: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var timerBar: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var meterTimer:Timer!
    var soundFileURL:URL!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func updateAudioMeter(_ timer:Timer) {
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                timerBar.text = s
                progressBar.progressTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                progressBar.progress += 0.001
            }
        }
    }
    
    @IBAction func recButton(_ sender: UIButton) {
        
        print("\(#function)")
        
        if player != nil {
            print("stopping: recordButton was pressed during Playing")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            rec.setTitle("Pause", for:.normal)
            play.isEnabled = false
            stop.isEnabled = true
            delete.isEnabled = false
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
            stop.isEnabled = true
            rec.setTitle("Continue", for:.normal)
            
        } else {
            print("recording")
            rec.setTitle("Pause", for:.normal)
            play.isEnabled = false
            delete.isEnabled = false
            stop.isEnabled = true
            recordWithPermission(false)
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        play.isEnabled = false
        stop.isEnabled = true
        playOn()
    }
    
    func playOn() {
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
            delete.isEnabled = false
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
        meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                          target:self,
                                          selector:#selector(self.updateAudioMeter(_:)),
                                          userInfo:nil,
                                          repeats:true)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        progressBar.progress = 0
        rec.setTitle("Record", for: .normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            play.isEnabled = true
            delete.isEnabled = true
            rec.isEnabled = false
            stop.isEnabled = false
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        let url = self.soundFileURL!
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
            print("error deleting recording")
        }
        progressBar.progress = 0
        rec.isEnabled = true
        delete.isEnabled = false
        play.isEnabled = false
        stop.isEnabled = false
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
    
}