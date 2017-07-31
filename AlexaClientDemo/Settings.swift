//
//  Settings.swift
//  AlexaClientDemo
//
//  Created by Rofi Uddin on 7/19/17.
//  Copyright © 2017 Rofi Uddin. All rights reserved.
//

import Foundation
import AVFoundation

struct Settings {
    
    struct Credentials {
        static let APPLICATION_TYPE_ID = "alexaforshin"
        static let DSN = "12345"
        
        static let SCOPES = ["alexa:all"]
        static let SCOPE_DATA = "{\"alexa:all\":{\"productID\":\"\(APPLICATION_TYPE_ID)\"," +
        "\"productInstanceAttributes\":{\"deviceSerialNumber\":\"\(DSN)\"}}}"
    }

    struct Audio {
        static let TEMP_FILE_NAME = "alexa.wav"
        static let RECORDING_SETTING =
            [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 1,
             AVSampleRateKey: 16000.0] as [String : Any]
        static let SILENCE_THRESHOLD = -30.0 as Float
    }
}
