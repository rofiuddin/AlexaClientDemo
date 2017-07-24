//
//  FirstViewController.swift
//  AlexaClientDemo
//
//  Created by Rofi Uddin on 7/11/17.
//  Copyright © 2017 Rofi Uddin. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var statusText: UILabel!

    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the document directory. If fails, just skip the rest of the code
        guard let directoryURL = FileManager.default.urls(for:
            FileManager.SearchPathDirectory.documentDirectory, in:
            FileManager.SearchPathDomainMask.userDomainMask).first else {
                let alertMessage = UIAlertController(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default,
                    handler: nil))
                    present(alertMessage, animated: true, completion: nil)
                return
        }
        
        // Setup the default audio file
        let audioFileURL = directoryURL.appendingPathComponent("MyRecordedAudio.m4a")
        
        // Setup the audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            
            // Define the recorder setting
            let recorderSetting: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // Initiate and prepare the recorder
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings:
                recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Action methods
    @IBAction func record(_ sender: UIButton) {
        // Stop the audio player before recording
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(true)
                    // Start recording
                    recorder.record(forDuration: 20)
                    // Change the status label
                    statusText.text = "Recording..."
                    recordButton.backgroundColor = UIColor.red
                } catch {
                    print(error)
                }
            } else {
                // Stop the audio recorder
                recorder.stop()
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(false)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: Delegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully
        flag: Bool) {
        if flag {
            // Change the status label
            statusText.text = "Tap to start recording"
            recordButton.backgroundColor = UIColor(red: 84/255.0, green: 137/255.0, blue: 255/255.0, alpha: 1)
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                print(error)
            }
            let alertMessage = UIAlertController(title: "Finish Recording",
                                                 message: "Successfully recorded the audio!", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default,
                                                 handler: nil))
            present(alertMessage, animated: true, completion: nil)
        }
    }
}

