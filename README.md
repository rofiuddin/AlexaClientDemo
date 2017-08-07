# AlexaClientDemo
A sample iOS/Swift3 app that brings Alexa Voice Service to your iPhone.

Instructions:
* Modify Bundle Identifier to something you like.
* [Register](https://developer.amazon.com/avs/home.html#/) a new product with Alexa Voice Service, select product type: application. Please take a note of your Application Type ID. 
* Create a Security Profile, create a new API key with your new Bundle Identifier under iOS Settings. Note down your API Key. 
* Modify the value of APPLICATION_TYPE_ID under "Settings.swift" to use your Application Type ID. 
* Modify the value of APIKey under "info.plist" to use your API key.
* Modify the entries under "info.plist" -> URL types, replace URL Schemes -> Item 0 and URL identifier with your Bundle Identifier. Please make sure that CFBundleURLSchemes needs to have prefix "amzn-".
* To change parameters such as [ASR Profile](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/reference/speechrecognizer#profiles), modify the value of AUDIO_EVENT_DATA under "AlexaVoiceServiceClient.swift".
