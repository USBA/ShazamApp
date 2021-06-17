//
//  ContentView.swift
//  ShazamApp
//
//  Created by Umayanga Alahakoon on 6/16/21.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @ObservedObject var shazamSession = ShazamRecognizer()
    
    var body: some View {
        ZStack {
            if let track = shazamSession.matchedTrack {
                // blured background
                AsyncImage(url: track.artwork) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    } else {
                        Color(.systemBackground)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .clipped()
                .overlay(.ultraThinMaterial)
            }
            
            VStack {
                if let track = shazamSession.matchedTrack {
                    TrackDetails(shazamSession: shazamSession, track: track)
                }
                
                ListenButton(shazamSession: shazamSession)
            }
            .frame(maxWidth: 500, alignment: .center)
            .padding()
        }
        .alert(shazamSession.errorMessage, isPresented: $shazamSession.showError) {
            Button("Close", role: .cancel) {
                shazamSession.showError = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
