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

}
