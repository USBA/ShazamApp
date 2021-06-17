//
//  ListenButton.swift
//  ShazamApp
//
//  Created by Umayanga Alahakoon on 6/17/21.
//

import SwiftUI

struct ListenButton: View {
    @ObservedObject var shazamSession: ShazamRecognizer
    @AppStorage("wannaKeepListening") var wannaKeepListening = true
    
    @State var size: CGFloat = 1
    
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
        .repeatForever()
    }
    
    var body: some View {
        Menu {
            Picker(selection: $wannaKeepListening, label: Text("Want to keep listening?")) {
                Text("No").tag(false)
                Text("Yes").tag(true)
            }
            Text("Want to keep listening?")
        } label: {
            Image(systemName: shazamSession.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .font(.system(size: 70).bold())
                .foregroundStyle(.white, .mint)
                .scaleEffect(size)
                .onChange(of: shazamSession.isRecording) { isRecording in
                    if isRecording {
                        withAnimation(repeatingAnimation) { size = 1.05 }
                    } else {
                        withAnimation { size = 1 }
                    }
                }
        } primaryAction: {
            if shazamSession.isRecording {
                shazamSession.stopRecording()
            } else {
                shazamSession.listenMusic()
            }
        }
        .padding()
    }
}
