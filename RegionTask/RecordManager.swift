//
//  RecordManager.swift
//  RegionTask
//
//  Created by Alexander Römer on 29.12.19.
//  Copyright © 2019 Alexander Römer. All rights reserved.
//

import Foundation
import Speech
import Combine

class RecordManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    
    let audioEngine                           = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request                               = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask                       : SFSpeechRecognitionTask?
    var text                                  = "" { willSet { objectWillChange.send() } }
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func recordAndRecognizeSpeech() {
        
        if(audioEngine.isRunning){
            audioEngine.stop()
            request.endAudio()
            let inputNode = audioEngine.inputNode
            let bus = 0
            inputNode.removeTap(onBus: bus)
            self.audioEngine.stop()
            self.text = ""
        } else {
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, audioTime) in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch let error {
                print(error.localizedDescription)
            }
            
            guard let myRecognizer = SFSpeechRecognizer() else { return }
            
            if !myRecognizer.isAvailable {
                return
            }
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                
                if let errorMessage = error  {
                    print(errorMessage)
                    return
                }
                
                if let result = result {
                    let bestString = result.bestTranscription.formattedString
                    self.text = bestString
                    print(self.text, result)
                }
            })
        }
        
    }
    
    
    
    
}
