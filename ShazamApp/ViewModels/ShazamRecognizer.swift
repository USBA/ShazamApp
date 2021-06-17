//
//  ShazamRecognizer.swift
//  ShazamApp
//
//  Created by Umayanga Alahakoon on 6/16/21.
//

import SwiftUI
import ShazamKit
import AVKit

class ShazamRecognizer: NSObject, ObservableObject, SHSessionDelegate {
    @Published var session = SHSession()
    @Published var audioEngine = AVAudioEngine()
    
    @Published var isRecording = false
    @Published var matchedTrack : Track!
    @Published var errorMessage = ""
    @Published var showError = false
    
    @AppStorage("wannaKeepListening") var wannaKeepListening = true
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        // match found
        if let firstItem = match.mediaItems.first {
            DispatchQueue.main.async {
                withAnimation {
                    self.matchedTrack = Track(title: firstItem.title,
                                              artist: firstItem.artist,
                                              artwork: firstItem.artworkURL,
                                              genres: firstItem.genres,
                                              appleMusicURL: firstItem.appleMusicURL)
                }
            }
            
            if !self.wannaKeepListening {
                self.stopRecording()
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        //no match
        DispatchQueue.main.async {
            if !self.wannaKeepListening {
                self.stopRecording()
            }
        }
    }
    
    // stop recording
    func stopRecording() {
        audioEngine.stop()
        DispatchQueue.main.async {
            withAnimation {
                self.isRecording = false
            }
        }
    }
    
    // fetch music
    func listenMusic() {
        let audioSession = AVAudioSession.sharedInstance()
        
        // check for permission
        audioSession.requestRecordPermission { status in
            if status {
                self.recordAudio()
            } else {
                self.errorMessage = "Please allow microphone access to start listening"
                self.showError = true
            }
        }
    }
    
    func recordAudio() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            return
        }
        
        // recording audio
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: .zero)
        
        inputNode.removeTap(onBus: .zero)
        
        inputNode.installTap(onBus: .zero, bufferSize: 1024, format: format) { buffer, time in
            // start shazam session
            self.session.matchStreamingBuffer(buffer, at: time)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            print("Started")
            withAnimation {
                isRecording = true
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
