//
//  FirstViewController.swift
//  AlexaClientDemo
//
//  Created by Rofi Uddin on 7/11/17.
//  Copyright © 2017 Rofi Uddin. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var pingButton: UIButton!

    private let audioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    private var isRecording = false
    
    private var avsClient = AlexaVoiceServiceClient()
    private var speakToken: String?

    private var stopCaptureTimer: Timer!
    private var isListening = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avsClient.pingHandler = self.pingHandler
        avsClient.directiveHandler = self.directiveHandler
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action methods
    @IBAction func record(_ sender: UIButton) {
        if (self.isRecording) {
            audioRecorder.stop()
            
            self.isRecording = false
            statusText.text = "Tap to start recording"
            recordButton.backgroundColor = UIColor(red: 84/255.0, green: 137/255.0, blue: 255/255.0, alpha: 1)
            do {
                try avsClient.postRecording(audioData: Data(contentsOf: audioRecorder.url))
            } catch let ex {
                print("AVS Client threw an error: \(ex.localizedDescription)")
            }
        } else {
            prepareAudioSession()
            
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            self.isRecording = true
            statusText.text = "Recording...Tap to stop"
            recordButton.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func onClickPingBtn(_ sender: Any) {
        avsClient.ping()
    }
    
    func pingHandler(isSuccess: Bool) {
        DispatchQueue.main.async { () -> Void in
            if (isSuccess) {
                self.statusText.text = "Ping success!"
            } else {
                self.statusText.text = "Ping failure!"
            }
        }
    }
    
    func directiveHandler(directives: [DirectiveData]) {
        // Store the token for directive "Speak"
        for directive in directives {
            if (directive.contentType == "application/json") {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: directive.data) as! [String:Any]
                    let directiveJson = jsonData["directive"] as! [String:Any]
                    let header = directiveJson["header"] as! [String:String]
                    if (header["name"] == "Speak") {
                        let payload = directiveJson["payload"] as! [String:String]
                        self.speakToken = payload["token"]!
                    }
                } catch let ex {
                    print("Directive data has an error: \(ex.localizedDescription)")
                }
            }
        }
        
        // Play the audio
        for directive in directives {
            if (directive.contentType == "application/octet-stream") {
                DispatchQueue.main.async { () -> Void in
                    self.statusText.text = "Alexa is speaking"
                }
                do {
                    self.avsClient.sendEvent(namespace: "SpeechSynthesizer", name: "SpeechStarted", token: self.speakToken!)
                    
                    try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:[AVAudioSessionCategoryOptions.allowBluetooth, AVAudioSessionCategoryOptions.allowBluetoothA2DP])
                    try self.audioPlayer = AVAudioPlayer(data: directive.data)
                    self.audioPlayer.delegate = self
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                } catch let ex {
                    print("Audio player has an error: \(ex.localizedDescription)")
                }
            }
        }
    }
    
    func prepareAudioSession() {
        
        do {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = directory.appendingPathComponent(Settings.Audio.TEMP_FILE_NAME)
            try audioRecorder = AVAudioRecorder(url: fileURL, settings: Settings.Audio.RECORDING_SETTING as [String : AnyObject])
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:[AVAudioSessionCategoryOptions.allowBluetooth, AVAudioSessionCategoryOptions.allowBluetoothA2DP])
        } catch let ex {
            print("Audio session has an error: \(ex.localizedDescription)")
        }
    }
    
    // MARK: Delegate methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player is finished playing")
        self.statusText.text = "Tap to start recording"
        
        self.avsClient.sendEvent(namespace: "SpeechSynthesizer", name: "SpeechFinished", token: self.speakToken!)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio player has an error: \(String(describing: error?.localizedDescription))")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio recorder is finished recording")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio recorder has an error: \(String(describing: error?.localizedDescription))")
    }
    
}
