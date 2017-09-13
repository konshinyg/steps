// Ячейка HR-вопросов

import UIKit
import AVFoundation

class RecTableViewCell: UITableViewCell, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var rec: UIButton!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var addTextLabel: UILabel!
    @IBOutlet weak var recorderTimerBar: UILabel!
    @IBOutlet weak var playerTimerBar: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var meterTimer:Timer!
    var soundFileURL:URL!
    var isPlayerStopped = true
    let stopImageRed = UIImage(named: "stop-red_icon.png")
    let recImage = UIImage(named: "rec_icon.png")
    let playImage = UIImage(named: "play_icon.png")
    let stopImageGray = UIImage(named: "stop-gray_icon.png")
    var recordTime = 0.0

    override func awakeFromNib() { super.awakeFromNib() }
    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }

// MARK: - Time Meter
    func updateAudioMeter(_ timer:Timer) {
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                recorderTimerBar.text = s
                progressBar.trackTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            if !isPlayerStopped {
                let min = Int(player.currentTime / 60)
                let sec = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                playerTimerBar.text = s
                progressBar.progress = Float(player.currentTime/recordTime)
                progressBar.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                progressBar.progressTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                if !player.isPlaying {
                    stopOn()
                    rec.setImage(playImage, for: .normal)
                    isPlayerStopped = !isPlayerStopped
                    delete.isEnabled = true
                }
            }
        }
    }
    
// MARK: - recordButton
    @IBAction func recButton(_ sender: UIButton) {
        
        if recorder == nil {
            rec.setImage(stopImageRed, for: .normal)
            delete.isEnabled = false
            recordWithPermission(true)
            return
        }
        
        if recorder.isRecording {
            recordTime = recorder.currentTime
            stopOn()
            rec.setImage(playImage, for: .normal)
            delete.isEnabled = true
            return
        }
        
        if !recorder.isRecording {
            delete.isEnabled = true
            if isPlayerStopped {
                playOn()
                rec.setImage(stopImageGray, for: .normal)
            } else {
                stopOn()
                rec.setImage(playImage, for: .normal)
            }
            isPlayerStopped = !isPlayerStopped
            return
        }
    }
    
// MARK: - play function
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

    }
    
    func whatIfNotPlayedAnymore() {
    }
    
// MARK: - stop function
    func stopOn() {
        print("\(#function)")
        recorder?.stop()
        player?.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            delete.isEnabled = true
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        progressBar.progress = 0
        rec.setTitle("Rec", for: .normal)
        playerTimerBar.text = "00:00"
        progressBar.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
// MARK: - deleteButton
    @IBAction func deleteButton(_ sender: UIButton) {
        let url = self.soundFileURL!
        stopOn()
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
            print("error deleting recording")
        }
        progressBar.progress = 0
        recorderTimerBar.text = "00:00"
        rec.setImage(recImage, for: .normal)
        delete.isEnabled = false
        recorder.isMeteringEnabled = false
        recorder = nil
    }
    
// MARK: - recording functions
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
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.01,
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
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey:             kAudioFormatMPEG4AAC,
            AVEncoderAudioQualityKey:  AVAudioQuality.min.hashValue,
            AVEncoderBitRateKey :      32000,
            AVNumberOfChannelsKey:     1,
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
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .allowAirPlay)
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
